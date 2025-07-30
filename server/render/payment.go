package main

import (
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
