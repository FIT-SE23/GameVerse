package main

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha512"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"os"
	"sort"
	"strconv"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func moveBoughtGamesToLibrary(c echo.Context, client *supabase.Client, userid string, paymentMethodId string) error {
	rep := client.Rpc("listgamesincart", "", map[string]string{"userid": userid})

	var items []map[string]string
	err := json.Unmarshal([]byte(rep), &items)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Empty list" /*err.Error()*/, "")
	}

	for _, item := range items {
		price, err := strconv.ParseFloat(item["price"], 64)
		fmt.Println("price", price)
		if err != nil {
			continue
		}
		transaction := map[string]any{
			"senderid":        userid,
			"receiverid":      item["publisherid"],
			"paymentmethodid": paymentMethodId,
			"moneyamount":     price,
		}
		rep, _, err = client.From("Transaction").Insert(transaction, false, "", "", "").ExecuteString()
		if err != nil {
			fmt.Println(err.Error(), rep)
		}
	}

	rep, _, err = client.From("User_Game").Update(map[string]string{"status": "In library"}, "", "").Eq("userid", userid).ExecuteString()
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
	serverURL := "http://localhost:1323/"
	url := "https://api-m.sandbox.paypal.com/v1/payments/payment"
	id := os.Getenv("PP_ID")
	secret := os.Getenv("PP_SECRET")
	accessToken := getAccessToken(id, secret)
	if accessToken == "" {
		return jsonResponse(c, http.StatusBadRequest, "Cannot get access token", "")
	}

	rep := client.Rpc("listgamesincart", "", map[string]string{"userid": userid})

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
		delete(item, "publisherid")
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
	fmt.Println(result)

	return jsonResponse(c, http.StatusOK, "", result["links"])
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
	paymentData := map[string]any{
		"payer_id": payerId,
	}

	jsonData, err := json.Marshal(paymentData)
	if err != nil {
		fmt.Println("Error marshalling JSON:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	_, err = http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Println("Error creating request:", err)
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

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
	rep := client.Rpc("listgamesincart", "", map[string]string{"userid": userid})

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

	serverURL := "http://localhost:1323/"
	vnpayUrl := "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?"
	vnpCode := "PX1TC5P1"
	vnpHashSecret := "XCUZD9M7ACRAFZSTCFMBRPMPGARJ8981"
	utc := time.Now().UTC()
	now := utc.Add(time.Hour * 7)
	expireTime := now.Add(time.Minute * 15)
	query := map[string]string{
		"vnp_Amount":     strconv.FormatFloat(total, 'f', 2, 64),
		"vnp_Command":    "pay",
		"vnp_CreateDate": fmt.Sprintf("%d%02d%02d%02d%02d%02d", now.Year(), int(now.Month()), now.Day(), now.Hour(), now.Minute(), now.Second()),
		"vnp_CurrCode":   "VND",
		"vnp_ExpireDate": fmt.Sprintf("%d%02d%02d%02d%02d%02d", expireTime.Year(), int(expireTime.Month()), expireTime.Day(), expireTime.Hour(), expireTime.Minute(), expireTime.Second()),
		"vnp_IpAddr":     ipAddr,
		"vnp_Locale":     "en",
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
	_, err = io.ReadAll(res.Body)
	if err != nil {
		fmt.Println("IO read all", err)
		return err
	}

	return jsonResponse(c, http.StatusOK, "", vnpayUrl+queryString)
}
