package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetTransactions(c echo.Context, client *supabase.Client, userid string) error {
	return model.GetTransactions(c, client, userid)
}
