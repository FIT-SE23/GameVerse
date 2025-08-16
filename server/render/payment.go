package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func addPaymentMethod(c echo.Context, client *supabase.Client) error {
	paymentType := c.FormValue("type")
	information := c.FormValue("information")

	payment := map[string]string{
		"type":        paymentType,
		"information": information,
	}
	_, _, err := client.From("PaymentMethod").Insert(payment, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func getPaymentMethods(c echo.Context, client *supabase.Client) error {
	paymentMethods, _, err := client.From("PaymentMethod").Select("*", "", false).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var methods []map[string]any
	err = json.Unmarshal([]byte(paymentMethods), &methods)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid payment methods", "")
	}

	return jsonResponse(c, http.StatusOK, "", methods)
}
