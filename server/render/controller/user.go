package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetUser(c echo.Context, client *supabase.Client) error {
	return model.GetUser(c, client)
}

func AddUser(c echo.Context, client *supabase.Client) error {
	return model.AddUser(c, client)
}

func SearchUsers(c echo.Context, client *supabase.Client) error {
	return model.SearchUsers(c, client)
}

func CreateUserToken(userid string) string {
	return model.CreateUserToken(userid)
}

func CreatePasswordResetToken(email string) string {
	return model.CreatePasswordResetToken(email)
}

func CreatePasswordResetOTP(email string) string {
	return model.CreatePasswordResetOTP(email)
}

func VerifyOAuthToken(c echo.Context, client *supabase.Client) error {
	return model.VerifyOAuthToken(c, client)
}

func VerifyToken(c echo.Context) error {
	return model.VerifyToken(c)
}

func VerifyPasswordResetToken(c echo.Context, client *supabase.Client) map[string]any {
	return model.VerifyPasswordResetToken(c, client)
}

func VerifyUserToken(c echo.Context) (string, error) {
	return model.VerifyUserToken(c)
}

func Login(c echo.Context, client *supabase.Client) error {
	return model.Login(c, client)
}

func GetGamesWithStatus(c echo.Context, client *supabase.Client, userid string, status string) error {
	return model.GetGamesWithStatus(c, client, userid, status)
}

func AddGameWithStatus(c echo.Context, client *supabase.Client, userGame map[string]string) error {
	return model.AddGameWithStatus(c, client, userGame)
}

func RemoveGameWithStatus(c echo.Context, client *supabase.Client, userGame map[string]string) error {
	return model.RemoveGameWithStatus(c, client, userGame)
}

func GetOwnedPost(c echo.Context, client *supabase.Client, userid string) error {
	return model.GetOwnedPost(c, client, userid)
}

func AddPlaytimeData(c echo.Context, client *supabase.Client) error {
	return model.AddPlaytimeData(c, client)
}

func GetPlaytimeData(c echo.Context, client *supabase.Client, userid string) error {
	return model.GetPlaytimeData(c, client, userid)
}

func UpdateUser(c echo.Context, client *supabase.Client) error {
	return model.UpdateUser(c, client)
}

func RecoverPassword(c echo.Context, client *supabase.Client) error {
	return model.RecoverPassword(c, client)
}
