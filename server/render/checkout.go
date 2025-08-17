package main

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha512"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func moveBoughtGamesToLibrary(c echo.Context, client *supabase.Client, userid string, paymentMethodId string) error {
	rep := client.Rpc("listgamesincart", "", map[string]string{"id": userid})

	var items []map[string]string
	err := json.Unmarshal([]byte(rep), &items)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Empty list" /*err.Error()*/, "")
	}

	for _, item := range items {
		price, err := strconv.ParseFloat(item["price"], 64)
		// fmt.Println("price", price)
		if err != nil {
			continue
		}

		now := time.Now()
		createDate := fmt.Sprintf("%d-%02d-%02d %02d:%02d:%02d", now.Year(), int(now.Month()), now.Day(), now.Hour(), now.Minute(), now.Second())

		transaction := map[string]any{
			"senderid":        userid,
			"gameid":          item["sku"],
			"paymentmethodid": paymentMethodId,
			"moneyamount":     price,
			"isrefundable":    true,
			"transactiondate": createDate,
		}
		rep, _, err = client.From("Transaction").Insert(transaction, false, "", "", "").ExecuteString()
		if err != nil {
			fmt.Println(err.Error(), rep)
		}
	}

	rep, _, err = client.From("User_Game").Update(map[string]string{"status": "In library"}, "", "").Eq("userid", userid).Eq("status", "In cart").ExecuteString()
	if err != nil {
		fmt.Println(err.Error(), rep)
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func getAccessToken(id string, secret string) string {
	url := "https://api-m.sandbox.paypal.com/v1/oauth2/token"
	data := []byte("grant_type=client_credentials")
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(data))
	if err != nil {
		fmt.Println(err)
		return ""
	}

	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	auth := id + ":" + secret
	req.Header.Set("Authorization", "Basic "+base64.StdEncoding.EncodeToString([]byte(auth)))

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println(err)
		return ""
	}

	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Println(err)
		return ""
	}

	var result map[string]any
	err = json.Unmarshal(body, &result)
	if err != nil {
		fmt.Println(err)
		return ""
	}
	if result["access_token"] == "" {
		return ""
	}

	switch token := result["access_token"].(type) {
	case string:
		return token
	default:
		return ""
	}
}

func createPaypalReceipt(c echo.Context, client *supabase.Client, userid string) error {
	serverURL := os.Getenv("SERVER_URL")
	if serverURL == "" {
		serverURL = "http://localhost:1323/"
	}

	url := "https://api-m.sandbox.paypal.com/v1/payments/payment"
	id := os.Getenv("PP_ID")
	secret := os.Getenv("PP_SECRET")
	accessToken := getAccessToken(id, secret)
	if accessToken == "" {
		return jsonResponse(c, http.StatusBadRequest, "Cannot get access token", "")
	}

	rep := client.Rpc("listgamesincart", "", map[string]string{"id": userid})

	var items []map[string]string
	err := json.Unmarshal([]byte(rep), &items)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Empty list" /*err.Error()*/, "")
	}

	total := 0.0
	for _, item := range items {
		item["currency"] = "USD"
		item["quantity"] = "1"

		amount, err := strconv.ParseFloat(item["price"], 64)
		if err == nil {
			total += amount
		}
	}

	paymentData := map[string]any{
		"intent": "authorize",
		"payer": map[string]string{
			"payment_method": "paypal",
		},
		"transactions": []map[string]any{
			{
				"amount": map[string]any{
					"total":    strconv.FormatFloat(total, 'f', 2, 64),
					"currency": "USD", // ?
				},
				"description":    "The payment transaction description.",   // transaction's id
				"invoice_number": userid + time.Now().Format(time.RFC3339), // transaction's id
				"payment_options": map[string]string{
					"allowed_payment_method": "INSTANT_FUNDING_SOURCE",
				},
				"soft_descriptor": "ECHI5786786",
				"item_list": map[string]any{
					"items": items,
					"shipping_address": map[string]string{
						"line1":        userid, // Username
						"city":         "San Jose",
						"state":        "CA",
						"postal_code":  "95131", // ?
						"country_code": "US",    // ?
					},
				},
			},
		},
		"redirect_urls": map[string]string{
			"return_url": serverURL + "paypal/return",
			"cancel_url": serverURL + "paypal/cancel",
		},
	}

	jsonData, err := json.Marshal(paymentData)
	if err != nil {
		fmt.Println("Error marshalling JSON:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Println("Error creating request:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	// Set the headers
	req.Header.Set("Authorization", "Bearer "+accessToken)
	req.Header.Set("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println(err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Println(err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var result map[string]any
	err = json.Unmarshal(body, &result)
	if err != nil {
		fmt.Println(err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	if result["state"] == nil {
		return jsonResponse(c, http.StatusBadRequest, "Cannot create receipt", result["details"])
	}

	links, ok := result["links"].([]map[string]any)
	if !ok {
		return jsonResponse(c, http.StatusOK, "", result["links"])
	}
	return jsonResponse(c, http.StatusOK, "", links[1])
}

func checkPaypalPaymentIdValid(accessToken string, paymentId string) (bool, error) {
	url := "https://api.sandbox.paypal.com/v1/payments/payment/" + paymentId
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		fmt.Println("Error creating request:", err)
		return false, errors.New("cannot create request")
	}

	req.Header.Set("Authorization", "Bearer "+accessToken)
	req.Header.Set("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println(err)
		return false, err
	}

	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Println(err)
		return false, err
	}
	var result map[string]any
	err = json.Unmarshal(body, &result)
	if err != nil {
		fmt.Println(err)
		return false, err
	}

	fmt.Println(result)

	state, exists := result["state"]
	if !exists {
		return true, nil
	}
	return state != "approved", nil
}

func checkoutPaypal(c echo.Context, client *supabase.Client) error {
	payerId := c.QueryParam("PayerID")
	paymentId := c.QueryParam("paymentId")
	id := os.Getenv("PP_ID")
	secret := os.Getenv("PP_SECRET")
	url := "https://api.sandbox.paypal.com/v1/payments/payment/" + paymentId + "/execute"
	accessToken := getAccessToken(id, secret)
	if accessToken == "" {
		return jsonResponse(c, http.StatusBadRequest, "Cannot get access token", "")
	}

	if valid, err := checkPaypalPaymentIdValid(accessToken, paymentId); !valid || err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Checkout failed", "")
	}
	paymentData := map[string]any{
		"payer_id": payerId,
	}

	jsonData, err := json.Marshal(paymentData)
	if err != nil {
		fmt.Println("Error marshalling JSON:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	/*
		_, err = http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
		if err != nil {
			fmt.Println("Error creating request:", err)
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
	*/

	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Println("Error creating request:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	req.Header.Set("Authorization", "Bearer "+accessToken)
	req.Header.Set("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println(err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Println(err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var result map[string]any
	err = json.Unmarshal(body, &result)
	if err != nil {
		fmt.Println(err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	state, ok := result["state"].(string)
	if !ok || state != "approved" {
		return jsonResponse(c, http.StatusBadRequest, "Transaction failed", "")
	}

	var userid string
	if payer, ok := result["payer"].(map[string]any); !ok {
		return jsonResponse(c, http.StatusBadRequest, "Transaction failed: payer", "")
	} else if payerInfo, ok := payer["payer_info"].(map[string]any); !ok {
		return jsonResponse(c, http.StatusBadRequest, "Transaction failed: payerInfo", "")
	} else if address, ok := payerInfo["shipping_address"].(map[string]any); !ok {
		return jsonResponse(c, http.StatusBadRequest, "Transaction failed: address", "")
	} else if userid, ok = address["line1"].(string); !ok {
		return jsonResponse(c, http.StatusBadRequest, "Transaction failed: line1", "")
	}

	return moveBoughtGamesToLibrary(c, client, userid, "a2f4772b-38ac-4fe2-b5a6-bead806c1221")
}

func createVnpayReceipt(c echo.Context, client *supabase.Client, userid string) error {
	rep := client.Rpc("listgamesincart", "", map[string]string{"id": userid})

	var items []map[string]string
	err := json.Unmarshal([]byte(rep), &items)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Empty list" /*err.Error()*/, "")
	}

	total := 0.0
	for _, item := range items {
		amount, err := strconv.ParseFloat(item["price"], 64)
		if err == nil {
			total += amount
		}
	}

	hostName, err := os.Hostname()
	if err != nil {
		return err
	}

	ipAddrs, err := net.LookupIP(hostName)
	if err != nil || len(ipAddrs) == 0 {
		return err
	}
	ipAddr := ipAddrs[0].String()

	serverURL := os.Getenv("SERVER_URL")
	if serverURL == "" {
		serverURL = "http://localhost:1323/"
	}
	vnpayUrl := "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?"
	vnpCode := os.Getenv("VNP_CODE")
	vnpHashSecret := os.Getenv("VNP_SECRET")
	utc := time.Now().UTC()
	now := utc.Add(time.Hour * 7)
	expireTime := now.Add(time.Minute * 15)
	query := map[string]string{
		"vnp_Amount":     strconv.FormatInt(int64(total*100*1000), 10),
		"vnp_Command":    "pay",
		"vnp_CreateDate": fmt.Sprintf("%d%02d%02d%02d%02d%02d", now.Year(), int(now.Month()), now.Day(), now.Hour(), now.Minute(), now.Second()),
		"vnp_CurrCode":   "VND",
		"vnp_ExpireDate": fmt.Sprintf("%d%02d%02d%02d%02d%02d", expireTime.Year(), int(expireTime.Month()), expireTime.Day(), expireTime.Hour(), expireTime.Minute(), expireTime.Second()),
		"vnp_IpAddr":     ipAddr,
		"vnp_Locale":     "vi",
		"vnp_OrderInfo":  userid, // ?
		"vnp_OrderType":  "billpayment",
		"vnp_ReturnUrl":  serverURL + "vnpay/return",
		"vnp_TmnCode":    vnpCode,
		"vnp_TxnRef":     userid + "|" + time.Now().Format(time.RFC3339),
		"vnp_Version":    "2.1.1",
	}

	keys := make([]string, 0, len(query))
	for k := range query {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	queryString := ""
	for seq, key := range keys {
		val := query[key]
		if seq == 0 {
			queryString = fmt.Sprintf("%s=%s", key, url.QueryEscape(fmt.Sprintf("%v", val)))
		} else {
			queryString += fmt.Sprintf("&%s=%s", key, url.QueryEscape(fmt.Sprintf("%v", val)))
		}
	}
	hmac := hmac.New(sha512.New, []byte(vnpHashSecret))
	hmac.Write([]byte(queryString))
	sum := hmac.Sum(nil)
	secureHash := hex.EncodeToString(sum)

	queryString += "&vnp_SecureHash=" + secureHash
	req, err := http.NewRequest("GET", vnpayUrl+queryString, bytes.NewBuffer([]byte{}))
	if err != nil {
		fmt.Println("Error creating request:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println("Error client do", err)
		return err
	}

	defer res.Body.Close()
	/*
		_, err = io.ReadAll(res.Body)
		if err != nil {
			fmt.Println("IO read all", err)
			return err
		}
	*/

	return jsonResponse(c, http.StatusOK, "", vnpayUrl+queryString)
}

func checkVNPPaymentIdValid(c echo.Context) (bool, error) {
	hostName, err := os.Hostname()
	if err != nil {
		fmt.Println("Hostname", err)
		return false, err
	}

	ipAddrs, err := net.LookupIP(hostName)
	if err != nil || len(ipAddrs) == 0 {
		fmt.Println("LookupIP", err)
		return false, err
	}
	txnRef := c.QueryParam("vnp_TxnRef")
	refList := strings.Split(txnRef, "|")
	if len(refList) != 2 {
		return false, errors.New("Missing vnp_TxnRef")
	}

	userid := refList[0]

	ipAddr := ipAddrs[0].String()
	vnpayUrl := "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction"
	vnpCode := os.Getenv("VNP_CODE")
	vnpHashSecret := os.Getenv("VNP_SECRET")
	utc := time.Now().UTC()
	now := utc.Add(time.Hour * 7)
	query := map[string]string{
		"vnp_RequestId":       txnRef,
		"vnp_Version":         "2.1.1",
		"vnp_Command":         "querydr",
		"vnp_TmnCode":         vnpCode,
		"vnp_TxnRef":          txnRef,
		"vnp_OrderInfo":       userid,
		"vnp_TransactionDate": c.QueryParam("vnp_PayDate"),
		"vnp_CreateDate":      fmt.Sprintf("%d%02d%02d%02d%02d%02d", now.Year(), int(now.Month()), now.Day(), now.Hour(), now.Minute(), now.Second()),
		"vnp_IpAddr":          ipAddr,
	}

	queryString := query["vnp_RequestId"] + "|" +
		query["vnp_Version"] + "|" +
		query["vnp_Command"] + "|" +
		query["vnp_TmnCode"] + "|" +
		query["vnp_TxnRef"] + "|" +
		query["vnp_TransactionDate"] + "|" +
		query["vnp_CreateDate"] + "|" +
		query["vnp_IpAddr"] + "|" +
		query["vnp_OrderInfo"]
	hmac := hmac.New(sha512.New, []byte(vnpHashSecret))
	hmac.Write([]byte(queryString))
	sum := hmac.Sum(nil)
	secureHash := hex.EncodeToString(sum)

	query["vnp_SecureHash"] = secureHash
	jsonData, err := json.Marshal(query)
	if err != nil {
		fmt.Println("Error marshalling JSON:", err)
		return false, err
	}
	req, err := http.NewRequest("POST", vnpayUrl, bytes.NewBuffer([]byte(jsonData)))
	if err != nil {
		return false, err
	}
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println("Error client do", err)
		return false, err
	}

	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Println("IO read all", err)
		return false, err
	}

	var response map[string]string
	err = json.Unmarshal(body, &response)
	if err != nil {
		return false, err
	}
	fmt.Println(response)

	return response["vnp_ResponseCode"] == "00", nil
}

func checkoutVnpay(c echo.Context, client *supabase.Client) error {
	responseCode := c.QueryParam("vnp_ResponseCode")
	if responseCode == "00" {
		txnRef := c.QueryParam("vnp_TxnRef")
		refList := strings.Split(txnRef, "|")
		if len(refList) != 2 {
			return jsonResponse(c, http.StatusBadGateway, "Vnpay response is missing vnp_TxnRef field", "")
		}

		userid := refList[0]
		if valid, err := checkVNPPaymentIdValid(c); !valid || err != nil {
			return jsonResponse(c, http.StatusBadRequest, "Checkout failed", "")
		}
		return moveBoughtGamesToLibrary(c, client, userid, "8fd6a904-efc7-4dad-b164-4694c103bf33")
	}
	transactionStatus := c.QueryParam("vnp_TransactionStatus")
	return jsonResponse(c, http.StatusBadGateway, "", map[string]string{"responsecode": responseCode, "transactionstatus": transactionStatus})
}
