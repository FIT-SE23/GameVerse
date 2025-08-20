package main

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
	"github.com/supabase-community/postgrest-go"
)

func getPost(c echo.Context, client *supabase.Client) error {
	postid := c.Param("id")

	rep, _, err := client.
			From("Post").
			Select("*", "", false).
			Eq("postid", postid).
			Single().
			ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var post map[string]any
	err = json.Unmarshal([]byte(rep), &post)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid post" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", post)
}

func addPost(c echo.Context, client *supabase.Client, userid string) error {
	forumid := c.FormValue("forumid")
	title := c.FormValue("title")
	content := c.FormValue("content")

	if forumid == "" || title == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing forumid or title", "")
	}

	post := map[string]any{
		"userid":    userid,
		"forumid":   forumid,
		"title":     title,
		"content":   content,
		"recommend": 0,
		"comments":  0,
	}

	rep, _, err := client.From("Post").Insert(post, false, "", "representation", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var results []map[string]any
	if err := json.Unmarshal([]byte(rep), &results); err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse response", "")
	}

	if len(results) == 0 {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to return post", "")
	}

	postId, ok := results[0]["postid"].(string)
	if !ok {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to get id from response", "")
	}

	return jsonResponse(c, http.StatusOK, "", postId)
}

func updatePost(c echo.Context, client *supabase.Client, userid string) error {
	postid := c.Param("id")

	rep, _, err := client.
		From("Post").
		Select("userid", "", false).
		Eq("postid", postid).
		Single().
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Post not found", "")
	}

	var postData map[string]any
	if err := json.Unmarshal([]byte(rep), &postData); err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid post data", "")
	}

	if postData["userid"] != userid {
		return jsonResponse(c, http.StatusForbidden, "No authorization", "")
	}

	content := c.FormValue("content")
	title := c.FormValue("title")

	if content == "" && title == "" {
		return jsonResponse(c, http.StatusBadRequest, "No data", "")
	}

	post := map[string]any{}
	if content != "" {
		post["content"] = content
	}
	if title != "" {
		post["title"] = title
	}

	_, _, err = client.
		From("Post").
		Update(post, "", "").
		Eq("postid", postid).
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func recommendPost(c echo.Context, client *supabase.Client, userid string) error {
	postid := c.FormValue("postid")
	if postid == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing post ID", "")
	}

	vote := map[string]string{
		"userid": userid,
		"postid": postid,
	}

	_, _, err := client.
		From("Post_Recommend").
		Select("*", "", false).
		Match(vote).
		Single().
		ExecuteString()

	if err == nil {
		_, _, err = client.
			From("Post_Recommend").
			Delete("", "").
			Match(vote).
			ExecuteString()

		if err != nil {
			return jsonResponse(c, http.StatusInternalServerError, "Failed to remove recommend", err.Error())
		}
		return jsonResponse(c, http.StatusOK, "", "")
	}

	_, _, err = client.
		From("Post_Recommend").
		Insert(vote, false, "", "", "").
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to add recommend", err.Error())
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func isPostRecommended(c echo.Context, client *supabase.Client, userID string, postID string) error {
	if postID == "" {
		return jsonResponse(c, http.StatusBadRequest, "Missing post ID", "")
	}

	vote := map[string]string{
		"postid": postID,
		"userid": userID,
	}

	rep, _, err := client.
		From("Post_Recommend").
		Select("*", "", false).
		Match(vote).
		ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Cant query from database", err.Error())
	}

	var result []map[string]any
	err = json.Unmarshal([]byte(rep), &result)
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse response", err.Error())
	}

	return jsonResponse(c, http.StatusOK, "", len(result) > 0)
}

func deletePost(c echo.Context, client *supabase.Client, userid string) error {
	postid := c.Param("id")

	rep, _, err := client.
		From("Post").
		Select("userid", "", false).
		Eq("postid", postid).
		Single().
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Post not found", "")
	}

	var post map[string]any
	if err := json.Unmarshal([]byte(rep), &post); err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid post data", "")
	}

	if post["userid"] != userid {
		return jsonResponse(c, http.StatusForbidden, "No authorization", "")
	}

	_, _, err = client.
		From("Post").
		Delete("", "").
		Eq("postid", postid).
		ExecuteString()

	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to delete post", err.Error())
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func searchPosts(c echo.Context, client *supabase.Client) error {
	forumId := c.QueryParam("forumid")
	if forumId == "" {
		return jsonResponse(c, http.StatusBadRequest, "forumid is required", "")
	}

	title := c.QueryParam("title")
	sortBy := c.QueryParam("sortby")
	limit, err := strconv.Atoi(c.QueryParam("limit"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	filter := client.
		From("Post").
		Select("*", "", false).
		Limit(limit, "").
		Eq("forumid", forumId)

	if title != "" {
		filter = filter.Like("title", "%"+title+"%")
	}

	switch sortBy {
	case "date":
		filter = filter.Order("postdate", &postgrest.OrderOpts{Ascending: false})
	default:
		filter = filter.Order("recommend", &postgrest.OrderOpts{Ascending: false})
	}

	rep, _, err := filter.ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var posts []map[string]any
	err = json.Unmarshal([]byte(rep), &posts)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", posts)
}

func listComments(c echo.Context, client *supabase.Client, postid string) error {
	sortBy := c.QueryParam("sortby")
	limit, err := strconv.Atoi(c.QueryParam("limit"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	filter := client.
		From("Comment").
		Select("*", "", false).
		Eq("postid", postid).
		Limit(limit, "")

	switch sortBy {
	case "date":
		filter = filter.Order("commentdate", &postgrest.OrderOpts{Ascending: false})
	default:
		filter = filter.Order("recommend", &postgrest.OrderOpts{Ascending: false})
	}

	rep, _, err := filter.ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), nil)
	}

	var comments []map[string]any
	err = json.Unmarshal([]byte(rep), &comments)
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse comments", nil)
	}

	return jsonResponse(c, http.StatusOK, "", comments)
}