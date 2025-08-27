package controller

import (
	"render/model"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func GetPost(c echo.Context, client *supabase.Client) error {
	return model.GetPost(c, client)
}

func SearchPosts(c echo.Context, client *supabase.Client) error {
	return model.SearchPosts(c, client)
}

func DeletePost(c echo.Context, client *supabase.Client, userID string) error {
	return model.DeletePost(c, client, userID)
}

func UpdatePost(c echo.Context, client *supabase.Client, userid string) error {
	return model.UpdatePost(c, client, userid)
}

func RecommendPost(c echo.Context, client *supabase.Client, userid string) error {
	return model.RecommendPost(c, client, userid)
}

func IsPostRecommended(c echo.Context, client *supabase.Client, userID string, postID string) error {
	return model.IsPostRecommended(c, client, userID, postID)
}

func AddPost(c echo.Context, client *supabase.Client, userid string) error {
	return model.AddPost(c, client, userid)
}

func ListComments(c echo.Context, client *supabase.Client, postid string) error {
	return model.ListComments(c, client, postid)
}
