package controller

import (
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
	return model.CreatePaypalReceipt(c, client, userid)
}

func CheckPaypalPaymentIdValid(accessToken string, paymentId string) (bool, error) {
	return model.CheckPaypalPaymentIdValid(accessToken, paymentId)
}

func CheckoutPaypal(c echo.Context, client *supabase.Client) (int, map[string]any) {
	return model.CheckoutPaypal(c, client)
}

func CreateVnpayReceipt(c echo.Context, client *supabase.Client, userid string) error {
	return model.CreateVnpayReceipt(c, client, userid)
}

func CheckVNPPaymentIdValid(c echo.Context) (bool, error) {
	return model.CheckVNPPaymentIdValid(c)
}

func CheckoutVnpay(c echo.Context, client *supabase.Client) (int, map[string]any) {
	return model.CheckoutVnpay(c, client)
}
