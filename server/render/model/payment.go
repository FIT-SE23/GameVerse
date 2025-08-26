package model

import (
	"encoding/json"
	"net/http"
	"render/config"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func AddPaymentMethod(c echo.Context, client *supabase.Client) error {
	paymentType := c.FormValue("type")
	information := c.FormValue("information")

	payment := map[string]string{
		"type":        paymentType,
		"information": information,
	}
	_, _, err := client.From("PaymentMethod").Insert(payment, false, "", "", "").ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return config.JsonResponse(c, http.StatusOK, "", "")
}

func GetPaymentMethods(c echo.Context, client *supabase.Client) error {
	paymentMethods, _, err := client.From("PaymentMethod").Select("*", "", false).ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var methods []map[string]any
	err = json.Unmarshal([]byte(paymentMethods), &methods)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Invalid payment methods", "")
	}

	return config.JsonResponse(c, http.StatusOK, "", methods)
}
