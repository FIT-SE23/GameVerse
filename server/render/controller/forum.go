package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetAllForums(c echo.Context, client *supabase.Client) error {
	return model.GetAllForums(c, client)
}

func GetForum(c echo.Context, client *supabase.Client) error {
	return model.GetForum(c, client)
}
