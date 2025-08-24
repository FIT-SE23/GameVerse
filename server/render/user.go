package main

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
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

func createPasswordResetToken(email string) string {
	claims := jwt.NewWithClaims(jwt.SigningMethodHS256,
		jwt.MapClaims{
			"email":      email,
			"authorized": true,
			"exp":        time.Now().Add(time.Minute * 10).Unix(),
		})

	gvSecret := os.Getenv("GV_SERECT")
	token, _ := claims.SignedString([]byte(gvSecret))
	return token
}

func createPasswordResetOTP(email string) string {
	const digits = "0123456789"
	const otpLen = 6
	code := make([]byte, otpLen)
	_, _ = rand.Read(code)
	for i := range code {
		code[i] = digits[int(code[i])%10]
	}
	return string(code)
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

func verifyPasswordResetToken(c echo.Context, client *supabase.Client) error {
	// email := c.FormValue("email")
	// otp := c.FormValue("otp")
	email := c.QueryParam("email")
	otp := c.QueryParam("otp")

	now := time.Now().UTC().Format("2006-01-02 15:04:05")
	fmt.Println("Now", now)
	_, _, err := client.From("Password_Reset_Token").Select("", "", false).Eq("email", email).Eq("otp", otp).Gte("expiredtime", now).Single().Execute()
	if err == nil {
		client.From("Password_Reset_Token").Delete("", "").Eq("email", email).ExecuteString()
	}
	return err
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
	fmt.Println("")
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
		Select("postid", "", false).
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

// function to add playtime data
func addPlaytimeData(c echo.Context, client *supabase.Client) error {
	userid, err := verifyUserToken(c)
	if err != nil {
		return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
	}

	begin := c.FormValue("begin")
	end := c.FormValue("end")

	data := map[string]any{
		"userid": userid,
		"begin":  begin,
		"end":    end,
	}

	_, _, err = client.From("User_Playtime").Insert(data, false, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	return jsonResponse(c, http.StatusOK, "Playtime data added successfully", "")
}

func getPlaytimeData(c echo.Context, client *supabase.Client, userid string) error {
	startDate := c.QueryParam("startDate")
	endDate := c.QueryParam("endDate")

	filter := client.
		From("User_Playtime").
		Select("*", "", false).
		Eq("userid", userid)

	if startDate != "" {
		filter = filter.Gt("begin", startDate)
	}
	if endDate != "" {
		filter = filter.Lt("end", endDate)
	}

	rep, _, err := filter.ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	var playtimeData []map[string]any
	err = json.Unmarshal([]byte(rep), &playtimeData)
	if err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse playtime data", "")
	}

	return jsonResponse(c, http.StatusOK, "", playtimeData)
}

func updateUser(c echo.Context, client *supabase.Client) error {
	userid := c.Param("id")

	rep, _, err := client.From("User").Select("userid", "", false).Eq("userid", userid).Single().ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusNotFound, "User not found!", err.Error())
	}

	var userData map[string]any
	if err := json.Unmarshal([]byte(rep), &userData); err != nil {
		return jsonResponse(c, http.StatusInternalServerError, "Failed to parse game data!", err.Error())
	}

	userID, ok := userData["userid"].(string)
	if !ok || userID == "" {
		return jsonResponse(c, http.StatusInternalServerError, "Could not determine the publisher of this game!", nil)
	}

	updates := map[string]any{}
	hashPassword := c.FormValue("hashpassword")
	if hashPassword != "" {
		updates["hashpassword"] = hashPassword
	}

	if len(updates) > 0 {
		_, _, err := client.From("User").Update(updates, "", "").Eq("userid", userid).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusInternalServerError, "Failed to update user information", err.Error())
		}
	}

	return jsonResponse(c, http.StatusOK, "", "")
}

func recoverPassword(c echo.Context, client *supabase.Client) error {
	email := c.QueryParam("email")
	otp := createPasswordResetOTP(email)

	_, _, err := client.From("Password_Reset_Token").Upsert(map[string]string{"email": email, "otp": otp, "expiredtime": time.Now().Add(time.Minute * 10).Format(time.RFC3339)}, "", "", "").ExecuteString()
	if err != nil {
		return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
	}

	htmlTemplate := `<!DOCTYPE html>
		<html>
		<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Password reset token</title>
		<style>
		@font-face {
		font-family: "Play";
		src: url(https://game-verse-bice.vercel.app/assets/assets/fonts/Play-Regular.ttf) format("truetype");
		}
		body {
		background-color: white;
		}
		.gray-box {
		background-color: #eaeaea;
		border-radius: 25px;
		width: 80%;
		text-align:center;
		margin: 0 auto;
		padding: 4% 4% 4% 4%;
		}
		.text {
		color: black;
		font-family: "Play", sans-serif;
		}
		.normal {
		font-size: 20px;
		text-align: left;
		}
		.bold {
		font-size: 32px;
		font-weight: bold;
		}
		.otp {
		margin-top:48px;
		display:inline-block;
		font-size:36px;
		font-weight:700;
		letter-spacing:24px;
		color:#fff;
		background-color:#0b57d0;
		padding:18px 24px 18px 24px;
		padding-right: 0px;
		border-radius:12px;
		}
		</style>
		</head>
		<body>
		<div class="gray-box">
		<!--<div style="background-image:url(https://game-verse-bice.vercel.app/assets/assets/logo/logo_vertical_black.svg" alt="GameVerse's logo" width="50%"> -->
		<p class="text bold">Password reset</p>
		`
	htmlTemplate += fmt.Sprintf(`<p class="text normal left">Hello,</p>
		<p class="text normal">You are receiving this email because a password reset was requested for your account.</p>
		<p class="text normal">To proceed with updating your password, please use the one-time password (OTP) below. This code is valid for 10 minutes.</p>
		<div class="otp">%s</div>
		<p class="text" style="text-align: center;font-size: 14px;color: gray">If you didn’t request this token, you can safely ignore this email.</p>
			`, otp)

	htmlTemplate += `		</div>
		</body>
		</html>
		`

	apiKey := os.Getenv("RESEND_KEY")
	mailContent := map[string]any{
		"from":    "GameVerse <gameverse@spoonie.tech>",
		"to":      []string{email},
		"subject": "Your OTP code",
		"html":    htmlTemplate,
	}

	body, _ := json.Marshal(mailContent)
	req, _ := http.NewRequestWithContext(context.Background(),
		http.MethodPost, "https://api.resend.com/emails", bytes.NewReader(body))
	req.Header.Set("Authorization", "Bearer "+apiKey)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Idempotency-Key", fmt.Sprintf("otp-%d", time.Now().UnixNano()))

	httpClient := &http.Client{Timeout: 10 * time.Second}
	res, err := httpClient.Do(req)
	if err != nil {
		panic(err)
	}
	defer res.Body.Close()

	body, _ = io.ReadAll(res.Body)
	if res.StatusCode != http.StatusOK {
		return jsonResponse(c, http.StatusBadRequest, "Send failed", string(body))
	}
	fmt.Println("Sent:", string(body))

	return jsonResponse(c, http.StatusOK, "", "An email has sent to email "+email)
}
