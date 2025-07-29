package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
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

func approvePayment(c echo.Context) error {
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
	fmt.Println(result)

	return jsonResponse(c, http.StatusBadRequest, "", "")
}
