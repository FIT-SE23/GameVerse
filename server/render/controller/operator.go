package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetGameRequests(c echo.Context, client *supabase.Client) error {
	return model.GetGameRequests(c, client)
}

func GetPublisherMessage(c echo.Context, client *supabase.Client) error {
	return model.GetPublisherMessage(c, client)
}

func AddPublisherMessage(c echo.Context, client *supabase.Client) error {
	return model.AddPublisherMessage(c, client)
}

func GetPublisherRequests(c echo.Context, client *supabase.Client) error {
	return model.GetPublisherRequests(c, client)
}

func VerifyPublisher(c echo.Context, client *supabase.Client) error {
	return model.VerifyPublisher(c, client)
}

func VerifyGame(c echo.Context, client *supabase.Client) error {
	return model.VerifyGame(c, client)
}

func AddGameMessage(c echo.Context, client *supabase.Client) error {
	return model.AddGameMessage(c, client)
}

func GetGameMessage(c echo.Context, client *supabase.Client) error {
	return model.GetGameMessage(c, client)
}
