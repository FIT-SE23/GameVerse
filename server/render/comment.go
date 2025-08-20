package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func getComment(c echo.Context, client *supabase.Client) error {
	commentid := c.Param("id")

	rep, _, err := client.
			From("Comment").
			Select("*", "", false).
			Eq("commentid", commentid).
			Single().
			ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var comment map[string]any
	err = json.Unmarshal([]byte(rep), &comment)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid comment" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", comment)
}

func addComment(c echo.Context, client *supabase.Client, userid string) error {
	postid := c.FormValue("postid")
	content := c.FormValue("content")

	if postid == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing postid", "")
	}

	comment := map[string]any{
		"userid":    userid,
		"postid":    postid,
		"content":   content,
		"recommend": 0,
	}

	rep, _, err := client.From("Comment").Insert(comment, true, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var newComment []map[string]any
	if err := json.Unmarshal([]byte(rep), &newComment); err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse inserted comment", "")
	}

	if len(newComment) == 0 {
		return jsonResponse(c, http.StatusInternalServerError, "Insert did not return ID", "")
	}
	
	commentId := newComment[0]["id"].(string)

	return jsonResponse(c, http.StatusOK, "", commentId)
}

func updateComment(c echo.Context, client *supabase.Client, userid string) error {
	commentid := c.Param("id")

	rep, _, err := client.
		From("Comment").
		Select("userid", "", false).
		Eq("commentid", commentid).
		Single().
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Comment not found", "")
	}

	var commentData map[string]any
	if err := json.Unmarshal([]byte(rep), &commentData); err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid comment data", "")
	}

	if commentData["userid"] != userid {
		return jsonResponse(c, http.StatusForbidden, "No authorization", "")
	}

	content := c.FormValue("content")

	if content == "" {
		return jsonResponse(c, http.StatusBadRequest, "No data", "")
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
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func recommendComment(c echo.Context, client *supabase.Client, userid string) error {
	commentid := c.FormValue("commentid")
	if commentid == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing comment ID", "")
	}

	vote := map[string]string{
		"userid": userid,
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
			return jsonResponse(c, http.StatusInternalServerError, "Failed to remove recommend", err.Error())
		}
		return jsonResponse(c, http.StatusOK, "", "")
	}

	_, _, err = client.
		From("Comment_Recommend").
		Insert(vote, false, "", "", "").
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to add recommend", err.Error())
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func isCommentRecommended(c echo.Context, client *supabase.Client, userID string, commentID string) error {
	if commentID == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing comment ID", "")
	}

	vote := map[string]string{
		"commentid": commentID,
		"userid":   userID,
	}

	rep, _, err := client.
		From("Comment_Recommend").
		Select("*", "", false).
		Match(vote).
		ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Cant query from database", err.Error())
	}

	var result []map[string]any
	if err := json.Unmarshal([]byte(rep), &result); err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse response", err.Error())
	}

	return jsonResponse(c, http.StatusOK, "", len(result) > 0)
}

func deleteComment(c echo.Context, client *supabase.Client, userid string) error {
	commentid := c.Param("id")

	rep, _, err := client.
		From("Comment").
		Select("userid", "", false).
		Eq("commentid", commentid).
		Single().
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Comment not found", "")
	}

	var comment map[string]any
	if err := json.Unmarshal([]byte(rep), &comment); err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid comment data", "")
	}

	if comment["userid"] != userid {
		return jsonResponse(c, http.StatusForbidden, "No authorization", "")
	}

	_, _, err = client.
		From("Comment").
		Delete("", "").
		Eq("commentid", commentid).
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to delete comment", err.Error())
	}

	return jsonResponse(c, http.StatusOK, "", "")
}