package main

import (
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"errors"
	"net/http"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func getUser(c echo.Context, client *supabase.Client) error {
	userid := c.Param("id")

	rep, _, err := client.From("User").Select("username, email", "", false).Eq("userid", userid).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var user map[string]any
	err = json.Unmarshal([]byte(rep), &user)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid userid" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", user)
}

func addUser(c echo.Context, client *supabase.Client) error {
	username := c.FormValue("username")
	email := c.FormValue("email")
	password := c.FormValue("password")
	checkSum := sha256.Sum256([]byte(password))
	hashPassword := hex.EncodeToString(checkSum[:])
	data := map[string]string{
		"username":     username,
		"email":        email,
		"hashpassword": hashPassword,
	}
	_, _, err := client.From("User").Insert(data, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	// TODO: "return" field
	return jsonResponse(c, http.StatusOK, "", "")
}

func searchUsers(c echo.Context, client *supabase.Client) error {
	username := c.QueryParam("username")
	rep, _, err := client.From("User").Select("userid, username", "", false).Like("username", "%"+username+"%").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var users []map[string]any
	err = json.Unmarshal([]byte(rep), &users)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "", users)
}

func encodeUserToken(userid string) string {
	now := time.Now().UTC().Format(time.RFC3339)
	raw := userid + "|" + now

	token := base64.StdEncoding.EncodeToString([]byte(raw))
	return token
}

func decodeUserToken(token string) (string, error) {
	raw, err := base64.StdEncoding.DecodeString(token)
	if err != nil {
		return "", err
	}

	info := strings.Split(string(raw), "|")
	if len(info) == 0 {
		return "", errors.New("invalid token")
	}

	userid := info[0]

	return userid, nil
}

func login(c echo.Context, client *supabase.Client) error {
	email := c.FormValue("email")
	password := c.FormValue("password")
	checkSum := sha256.Sum256([]byte(password))
	hashPassword := hex.EncodeToString(checkSum[:])
	rep, _, err := client.From("User").Select("userid", "", false).Eq("email", email).Eq("hashpassword", hashPassword).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid email or password" /*err.Error()*/, "")
	}

	var userid map[string]string
	err = json.Unmarshal([]byte(rep), &userid)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	return jsonResponse(c, http.StatusOK, "", encodeUserToken(userid["userid"]))
}

func getGamesWithStatus(c echo.Context, client *supabase.Client, userid string, status string) error {
	rep, _, err := client.From("User_Game").Select("Game(*)", "", false).Eq("userid", userid).Eq("status", status).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var user []map[string]any
	err = json.Unmarshal([]byte(rep), &user)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Empty list" /*err.Error()*/, "")
	}
	return jsonResponse(c, http.StatusOK, "", user)
}

func addGameWithStatus(c echo.Context, client *supabase.Client, userGame map[string]string) error {
	_, _, err := client.From("User_Game").Insert(userGame, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	// TODO: "return" field
	return jsonResponse(c, http.StatusOK, "", "")
}
