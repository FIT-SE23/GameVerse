package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

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
	id := os.Getenv("APP_ID")
	secret := os.Getenv("APP_SECRET")
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
	id := os.Getenv("APP_ID")
	secret := os.Getenv("APP_SECRET")
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

	rep := client.Rpc("listgamesincart", "", map[string]string{"userid": userid})

	var items []map[string]string
	err = json.Unmarshal([]byte(rep), &items)
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
			"paymentmethodid": "a2f4772b-38ac-4fe2-b5a6-bead806c1221",
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

	return jsonResponse(c, http.StatusOK, "", result["links"])
}
