package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetComment(c echo.Context, client *supabase.Client) error {
	return model.GetComment(c, client)
}

func AddComment(c echo.Context, client *supabase.Client, userid string) error {
	return model.AddComment(c, client, userid)
}

func UpdateComment(c echo.Context, client *supabase.Client, userid string) error {
	return model.UpdateComment(c, client, userid)
}

func RecommendComment(c echo.Context, client *supabase.Client, userid string) error {
	return model.RecommendComment(c, client, userid)
}

func IsCommentRecommended(c echo.Context, client *supabase.Client, userID string, commentID string) error {
	return model.IsCommentRecommended(c, client, userID, commentID)
}

func DeleteComment(c echo.Context, client *supabase.Client, userid string) error {
	return model.DeleteComment(c, client, userid)
}
