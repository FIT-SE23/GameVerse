package controller

import (
	"net/http"
	"strings"

	"render/config"
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func MoveBoughtGamesToLibrary(c echo.Context, client *supabase.Client, userid string, paymentMethodId string) (int, map[string]any) {
	return model.MoveBoughtGamesToLibrary(c, client, userid, paymentMethodId)
}

func GenCheckoutPage(info map[string]any) string {
	return model.GenCheckoutPage(info)
}

func GetAccessToken(id string, secret string) string {
	return model.GetAccessToken(id, secret)
}

func CreatePaypalReceipt(c echo.Context, client *supabase.Client, userid string) error {
	test := strings.ToLower(strings.TrimSpace(c.QueryParam("test")))
	if test == "success" {
		status, _ := MoveBoughtGamesToLibrary(c, client, userid, "a2f4772b-38ac-4fe2-b5a6-bead806c1221")
		return config.JsonResponse(c, status, "Test OK", "")
	}
	if test == "fail" {
		return config.JsonResponse(c, http.StatusOK, "Test FAIL", "")
	}
	return model.CreatePaypalReceipt(c, client, userid)
}

func CheckPaypalPaymentIdValid(accessToken string, paymentId string) (bool, error) {
	return model.CheckPaypalPaymentIdValid(accessToken, paymentId)
}

func CheckoutPaypal(c echo.Context, client *supabase.Client) (int, map[string]any) {
	return model.CheckoutPaypal(c, client)
}

func CreateVnpayReceipt(c echo.Context, client *supabase.Client, userid string) error {
	test := strings.ToLower(strings.TrimSpace(c.QueryParam("test")))
	if test == "success" {
		status, _ := MoveBoughtGamesToLibrary(c, client, userid, "8fd6a904-efc7-4dad-b164-4694c103bf33")
		return config.JsonResponse(c, status, "Test OK", "")
	}
	if test == "fail" {
		return config.JsonResponse(c, http.StatusOK, "Test FAIL", "")
	}
	return model.CreateVnpayReceipt(c, client, userid)
}

func CheckVNPPaymentIdValid(c echo.Context) (bool, error) {
	return model.CheckVNPPaymentIdValid(c)
}

func CheckoutVnpay(c echo.Context, client *supabase.Client) (int, map[string]any) {
	return model.CheckoutVnpay(c, client)
}
