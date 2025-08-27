package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func AddCategory(c echo.Context, client *supabase.Client) error {
	return model.AddCategory(c, client)
}

func GetCategories(c echo.Context, client *supabase.Client) error {
	return model.GetCategories(c, client)
}
