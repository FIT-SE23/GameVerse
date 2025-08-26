package model

import (
	"encoding/json"
	"net/http"
	"render/config"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

type Comment struct {
	CommentID   string    `json:"commentid" db:"commentid"`
	UserID      string    `json:"userid" db:"userid"`
	Content     string    `json:"content" db:"content"`
	PostID      string    `json:"postid" db:"postid"`
	ForumID     string    `json:"forumid" db:"forumid"`
	Recommend   string    `json:"recommend" db:"recommend"`
	CommentDate time.Time `json:"commentdate" db:"commentdate"`
}

func GetComment(c echo.Context, client *supabase.Client) error {
	commentid := c.Param("id")

	rep, _, err := client.
		From("Comment").
		Select("*", "", false).
		Eq("commentid", commentid).
		Single().
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var comment map[string]any
	err = json.Unmarshal([]byte(rep), &comment)
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Invalid comment" /*err.Error()*/, "")
	}
	return config.JsonResponse(c, http.StatusOK, "", comment)
}

func AddComment(c echo.Context, client *supabase.Client, userid string) error {
	postid := c.FormValue("postid")
	content := c.FormValue("content")

	if postid == "" {
		return config.JsonResponse(c, http.StatusBadRequest, "Missing postid", "")
	}

	comment := map[string]any{
		"userid":    userid,
		"postid":    postid,
		"content":   content,
		"recommend": 0,
	}

	rep, _, err := client.From("Comment").Insert(comment, false, "", "representation", "").ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var newComment []map[string]any
	if err := json.Unmarshal([]byte(rep), &newComment); err != nil {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to parse response", "")
	}

	if len(newComment) == 0 {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to return id", "")
	}

	commentId, ok := newComment[0]["commentid"].(string)
	if !ok {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to get id from response", "")
	}

	return config.JsonResponse(c, http.StatusOK, "", commentId)
}

func UpdateComment(c echo.Context, client *supabase.Client, userid string) error {
	commentid := c.Param("id")

	rep, _, err := client.
		From("Comment").
		Select("userid", "", false).
		Eq("commentid", commentid).
		Single().
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Comment not found", "")
	}

	var commentData map[string]any
	if err := json.Unmarshal([]byte(rep), &commentData); err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Invalid comment data", "")
	}

	if commentData["userid"] != userid {
		return config.JsonResponse(c, http.StatusForbidden, "No authorization", "")
	}

	content := c.FormValue("content")

	if content == "" {
		return config.JsonResponse(c, http.StatusBadRequest, "No data", "")
	}

	comment := map[string]any{}
	if content != "" {
		comment["content"] = content
	}

	_, _, err = client.
		From("Comment").
		Update(comment, "", "").
		Eq("commentid", commentid).
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return config.JsonResponse(c, http.StatusOK, "", "")
}

func RecommendComment(c echo.Context, client *supabase.Client, userid string) error {
	commentid := c.FormValue("commentid")
	if commentid == "" {
		return config.JsonResponse(c, http.StatusBadRequest, "Missing comment ID", "")
	}

	vote := map[string]string{
		"userid":    userid,
		"commentid": commentid,
	}

	_, _, err := client.
		From("Comment_Recommend").
		Select("*", "", false).
		Match(vote).
		Single().
		ExecuteString()

	if err == nil {
		_, _, err = client.
			From("Comment_Recommend").
			Delete("", "").
			Match(vote).
			ExecuteString()
		if err != nil {
			return config.JsonResponse(c, http.StatusInternalServerError, "Failed to remove recommend", err.Error())
		}
		return config.JsonResponse(c, http.StatusOK, "", "")
	}

	_, _, err = client.
		From("Comment_Recommend").
		Insert(vote, false, "", "", "").
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to add recommend", err.Error())
	}

	return config.JsonResponse(c, http.StatusOK, "", "")
}

func IsCommentRecommended(c echo.Context, client *supabase.Client, userID string, commentID string) error {
	if commentID == "" {
		return config.JsonResponse(c, http.StatusBadRequest, "Missing comment ID", "")
	}

	vote := map[string]string{
		"commentid": commentID,
		"userid":    userID,
	}

	rep, _, err := client.
		From("Comment_Recommend").
		Select("*", "", false).
		Match(vote).
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusInternalServerError, "Cant query from database", err.Error())
	}

	var result []map[string]any
	if err := json.Unmarshal([]byte(rep), &result); err != nil {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to parse response", err.Error())
	}

	return config.JsonResponse(c, http.StatusOK, "", len(result) > 0)
}

func DeleteComment(c echo.Context, client *supabase.Client, userid string) error {
	commentid := c.Param("id")

	rep, _, err := client.
		From("Comment").
		Select("userid", "", false).
		Eq("commentid", commentid).
		Single().
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Comment not found", "")
	}

	var comment map[string]any
	if err := json.Unmarshal([]byte(rep), &comment); err != nil {
		return config.JsonResponse(c, http.StatusBadRequest, "Invalid comment data", "")
	}

	if comment["userid"] != userid {
		return config.JsonResponse(c, http.StatusForbidden, "No authorization", "")
	}

	_, _, err = client.
		From("Comment").
		Delete("", "").
		Eq("commentid", commentid).
		ExecuteString()
	if err != nil {
		return config.JsonResponse(c, http.StatusInternalServerError, "Failed to delete comment", err.Error())
	}

	return config.JsonResponse(c, http.StatusOK, "", "")
}
