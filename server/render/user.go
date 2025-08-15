package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
	"github.com/supabase-community/postgrest-go"
	"github.com/supabase-community/supabase-go"
)

func getUser(c echo.Context, client *supabase.Client) error {
	userid := c.Param("id")

	rep, _, err := client.From("User").Select("userid, username, email, type", "", false).Eq("userid", userid).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var user map[string]any
	err = json.Unmarshal([]byte(rep), &user)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid userid" /*err.Error()*/, "")
	}
	user["id"] = userid
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
		fmt.Println("Error inserting user:", err)
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

func createUserToken(userid string) string {
	claims := jwt.NewWithClaims(jwt.SigningMethodHS256,
		jwt.MapClaims{
			"userid":     userid,
			"authorized": true,
			"exp":        time.Now().Add(time.Hour * 24).Unix(),
		})

	gvSecret := os.Getenv("GV_SERECT")
	token, _ := claims.SignedString([]byte(gvSecret))
	return token
}

func verifyOAuthToken(c echo.Context, client *supabase.Client) error {
	header := c.Request().Header
	auth := header["Authorization"]
	if len(auth) == 0 {
		return jsonResponse(c, http.StatusUnauthorized, "Require Authorization header", "")
	}
	rawToken := strings.Split(auth[0], " ")

	email := rawToken[1]
	// For OAuth, we assume the token is valid.
	// Find userid by email in the database
	rep, _, err := client.From("User").Select("userid", "", false).Eq("email", email).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusUnauthorized, "Invalid token", "")
	}
	var user map[string]string
	err = json.Unmarshal([]byte(rep), &user)
	if err != nil {
		return jsonResponse(c, http.StatusUnauthorized, "Invalid token", "")
	}
	userid, ok := user["userid"]
	if !ok {
		return jsonResponse(c, http.StatusUnauthorized, "Invalid token", "")
	}
	return jsonResponse(c, http.StatusOK, "", map[string]string{
		"userid": userid,
		"token":  createUserToken(userid),
	})
}

func verifyToken(c echo.Context) error {
	header := c.Request().Header
	auth := header["Authorization"]
	if len(auth) == 0 {
		return jsonResponse(c, http.StatusUnauthorized, "Require Authorization header", "")
	}

	rawToken := strings.Split(auth[0], " ")
	if len(rawToken) < 2 {
		return jsonResponse(c, http.StatusUnauthorized, "Invalid Authorization header", "")
	}

	token := rawToken[1]
	raw, err := jwt.Parse(token, func(token *jwt.Token) (any, error) {
		gvSecret := os.Getenv("GV_SERECT")
		return []byte(gvSecret), nil
	})
	if err != nil {
		return jsonResponse(c, http.StatusUnauthorized, "Invalid token", "")
	}

	if !raw.Valid {
		return jsonResponse(c, http.StatusUnauthorized, "Invalid token", "")
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func verifyUserToken(c echo.Context) (string, error) {
	header := c.Request().Header
	auth := header["Authorization"]
	if len(auth) == 0 {
		return "", errors.New("Require Authorization header")
	}

	rawToken := strings.Split(auth[0], " ")
	if len(rawToken) < 2 {
		return "", errors.New("Invalid Authorization header")
	}

	token := rawToken[1]
	raw, err := jwt.Parse(token, func(token *jwt.Token) (any, error) {
		gvSecret := os.Getenv("GV_SERECT")
		return []byte(gvSecret), nil
	})
	if err != nil {
		return "", err
	}

	if !raw.Valid {
		return "", errors.New("Invalid token")
	}

	claims, ok := raw.Claims.(jwt.MapClaims)
	if !ok {
		return "", nil
	}
	// fmt.Println("claims", claims)

	userid, ok := claims["userid"].(string)
	if !ok {
		return "", nil
	}
	// fmt.Println("userid", userid)

	return userid, nil
}

func login(c echo.Context, client *supabase.Client) error {
	email := c.FormValue("email")
	password := c.FormValue("password")
	checkSum := sha256.Sum256([]byte(password))
	hashPassword := hex.EncodeToString(checkSum[:])
	rep, _, err := client.From("User").Select("userid, type", "", false).Eq("email", email).Eq("hashpassword", hashPassword).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, "Invalid email or password" /*err.Error()*/, "")
	}

	var user map[string]string
	err = json.Unmarshal([]byte(rep), &user)
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}
	// return jsonResponse(c, http.StatusOK, "", createUserToken(userid["userid"]))
	// Return the user ID and token
	return jsonResponse(c, http.StatusOK, "", map[string]string{
		"userid": user["userid"],
		"token":  createUserToken(user["userid"]),
	})
}

func getGamesWithStatus(c echo.Context, client *supabase.Client, userid string, status string) error {
	rep, _, err := client.From("User_Game").Select("Game(gameid)", "", false).Eq("userid", userid).Eq("status", status).ExecuteString()
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

func removeGameWithStatus(c echo.Context, client *supabase.Client, userGame map[string]string) error {
	_, _, err := client.From("User_Game").Delete("", "").Eq("userid", userGame["userid"]).Eq("gameid", userGame["gameid"]).Eq("status", userGame["status"]).ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	// TODO: "return" field
	return jsonResponse(c, http.StatusOK, "", "")
}

func getOwnedPost(c echo.Context, client *supabase.Client, userid string) error {
	limit, err := strconv.Atoi(c.QueryParam("limit"))
	if err != nil || limit <= 0 {
		limit = 10
	}
	if limit > 100 {
		limit = 100
	}

	rep, _, err := client.
		From("Post").
		Select("*", "", false).
		Eq("userid", userid).
		Order("postdate", &postgrest.OrderOpts{Ascending: false}).
		Limit(limit, "").
		ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var posts []map[string]any
	err = json.Unmarshal([]byte(rep), &posts)
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse posts", "")
	}

	return jsonResponse(c, http.StatusOK, "", posts)
}
