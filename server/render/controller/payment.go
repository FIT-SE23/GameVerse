package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func AddPaymentMethod(c echo.Context, client *supabase.Client) error {
	return model.AddPaymentMethod(c, client)
}

func GetPaymentMethods(c echo.Context, client *supabase.Client) error {
	return model.GetPaymentMethods(c, client)
}
