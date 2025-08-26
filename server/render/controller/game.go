package controller

import (
	"mime/multipart"
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func AddResources(client *supabase.Client, userID string, gameID string, bucketId string, files []*multipart.FileHeader, resourceType string) []string {
	return model.AddResources(client, userID, gameID, bucketId, files, resourceType)
}

func DeleteResources(client *supabase.Client, bucketId string, resourceIDs []string) []string {
	return model.DeleteResources(client, bucketId, resourceIDs)
}

func AddGame(c echo.Context, client *supabase.Client, bucketId string) error {
	return model.AddGame(c, client, bucketId)
}

func GetGame(c echo.Context, client *supabase.Client) error {
	return model.GetGame(c, client)
}

func SearchGames(c echo.Context, client *supabase.Client) error {
	return model.SearchGames(c, client)
}

func UpdateGame(c echo.Context, client *supabase.Client, bucketId string) error {
	return model.UpdateGame(c, client, bucketId)
}

func RecommendGame(c echo.Context, client *supabase.Client, userID string) error {
	return model.RecommendGame(c, client, userID)
}

func IsRecommended(c echo.Context, client *supabase.Client, userID string, gameID string) error {
	return model.IsRecommended(c, client, userID, gameID)
}

func DownloadGame(c echo.Context, client *supabase.Client, userID string) error {
	return model.DownloadGame(c, client, userID)
}
