package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetPublisher(c echo.Context, client *supabase.Client) error {
	return model.GetPublisher(c, client)
}

func AddPublisher(c echo.Context, client *supabase.Client) error {
	return model.AddPublisher(c, client)
}

func UpdatePublisher(c echo.Context, client *supabase.Client) error {
	return model.UpdatePublisher(c, client)
}
