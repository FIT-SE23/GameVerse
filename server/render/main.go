package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"runtime"
	"slices"
	"strings"
	"time"

	"github.com/labstack/echo/v4"
	"github.com/supabase-community/supabase-go"
)

func _jsonResponse(c echo.Context, code int, message string, returnVal any) error {
	jsonData := map[string]any{
		"message": message,
		"return":  returnVal,
	}
	return c.JSON(code, jsonData)
}

func jsonResponse(c echo.Context, code int, message string, returnVal any) error {
	_, filename, line, _ := runtime.Caller(1)
	fmt.Println(filename, line)
	return _jsonResponse(c, code, message, returnVal)
}

func main() {
	supabaseURL := os.Getenv("SUPABASE_URL")
	supabaseKEY := os.Getenv("SUPABASE_KEY")
	client, err := supabase.NewClient(supabaseURL, supabaseKEY, nil)
	if err != nil {
		fmt.Println("cannot initalize client", err)
		return
	}

	bucketId := "root"

	e := echo.New()

	e.POST("/login", func(c echo.Context) error {
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
		return jsonResponse(c, http.StatusOK, "", userid)
	})

	e.POST("/user", func(c echo.Context) error {
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
	})

	e.GET("/user/:id", func(c echo.Context) error {
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
	})
	e.PATCH("/user/:id", func(c echo.Context) error {
		return jsonResponse(c, http.StatusBadRequest, "Unsupported request", "")
	})

	e.POST("/game", func(c echo.Context) error {
		publisherID := c.FormValue("publisherid")
		if publisherID == "" {
			return jsonResponse(c, http.StatusBadRequest, "Require publisherID", "")
		}

		// TODO: Check game's name length
		gameName := c.FormValue("gamename")
		description := c.FormValue("description")

		game := map[string]string{
			"publisherid": publisherID,
			"name":        gameName,
			"description": description,
		}
		_, _, err := client.From("Game").Insert(game, false, "", "", "").ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
		rep, _, err := client.From("Game").Select("gameid", "", false).Eq("publisherid", publisherID).Eq("name", gameName).Single().ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
		var gameID map[string]string
		err = json.Unmarshal([]byte(rep), &gameID)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, "Game uploaded but database does not return the id" /*err.Error()*/, "")
		}
		userID := publisherID

		// https://echo.labstack.com/docs/cookbook/file-upload
		form, err := c.MultipartForm()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		files := form.File["files"]
		errFiles := []string{}

		for _, file := range files {
			src, err := file.Open()
			if err != nil {
				errFiles = append(errFiles, file.Filename)
				fmt.Println("Read file failed", file.Filename, err)
				continue
			}
			defer src.Close()

			_, uplErr := client.Storage.UploadFile(bucketId, userID+"/res/"+strings.ReplaceAll(time.Now().UTC().Format(time.RFC3339), ":", "-")+file.Filename, src)
			if uplErr != nil {
				errFiles = append(errFiles, file.Filename)
				fmt.Println("Upload failed", file.Filename, uplErr)
				continue
			}

			signedURL, err := client.Storage.CreateSignedUrl(bucketId, userID+"/res/"+file.Filename, 365*24*60*60)
			if err != nil {
				errFiles = append(errFiles, file.Filename)
				fmt.Println("Create signed url failed", file.Filename, err)
				continue
			}

			resource := map[string]string{
				"userid": userID,
				"url":    signedURL.SignedURL,
			}
			_, _, err = client.From("Resource").Insert(resource, false, "", "", "").ExecuteString()
			if err != nil {
				errFiles = append(errFiles, file.Filename)
				continue
			}

			rep, _, err := client.From("Resource").Select("resourceid", "", false).Eq("url", resource["url"]).Single().ExecuteString()
			if err != nil {
				return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
			}
			var resourceid map[string]any
			err = json.Unmarshal([]byte(rep), &resourceid)
			if err != nil {
				return jsonResponse(c, http.StatusBadRequest, "Resource uploaded but database does not return the id" /*err.Error()*/, "")
			}
			gameResource := map[string]any{
				"gameid":     gameID["gameid"],
				"resourceid": resourceid["resourceid"],
			}
			_, _, err = client.From("Game_Resource").Insert(gameResource, false, "", "", "").ExecuteString()
			if err != nil {
				errFiles = append(errFiles, file.Filename)
			}
		}

		if len(errFiles) > 0 {
			return jsonResponse(c, http.StatusBadRequest, "Upload failed. Maybe the files do not exist or have been added or cannot link gameid with resourceid", errFiles)
		}

		rep, _, err = client.From("Category").Select("", "", false).ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
		var knownCategories []map[string]any
		err = json.Unmarshal([]byte(rep), &knownCategories)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		categories := strings.Split(c.FormValue("categories"), ",")
		errCat := []string{}

		for _, category := range categories {
			index := slices.IndexFunc(knownCategories, func(knownCategory map[string]any) bool {
				return knownCategory["categoryname"] == category
			})
			if index == -1 {
				errCat = append(errCat, category)
				continue
			}

			pair := map[string]any{
				"gameid":     gameID["gameid"],
				"categoryid": knownCategories[index]["categoryid"],
			}

			_, _, err = client.From("Game_Category").Insert(pair, true, "", "", "").ExecuteString()
			if err != nil {
				errCat = append(errCat, category)
				continue
			}
		}

		if len(errCat) > 0 {
			return jsonResponse(c, http.StatusBadRequest, "Unknown categories", errCat)
		}

		forum := map[string]string{
			"forumid": gameID["gameid"],
		}
		_, _, err = client.From("Forum").Insert(forum, false, "", "", "").ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		return jsonResponse(c, http.StatusOK, "", "")
	})

	e.GET("/game/:id", func(c echo.Context) error {
		gameID := c.Param("id")

		rep, _, err := client.From("Game").Select("publisherid, name, description, Category(categoryname), Resource(url)", "", false).Eq("gameid", gameID).Single().ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}
		var gameBasicInfo map[string]any
		err = json.Unmarshal([]byte(rep), &gameBasicInfo)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, "Invalid gameid" /*err.Error()*/, "")
		}

		return jsonResponse(c, http.StatusOK, "", gameBasicInfo)
	})
	e.PATCH("/game/:id", func(c echo.Context) error {
		return jsonResponse(c, http.StatusBadRequest, "Unsupported request", "")
	})

	e.GET("/search", func(c echo.Context) error {
		entity := c.QueryParam("entity")

		switch entity {
		case "user":
			{
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
		case "game":
			{
				gamename := c.QueryParam("gamename")
				rep, _, err := client.From("Game").Select("*, Category(categoryname), Resource(url)", "", false).Like("name", "%"+gamename+"%").ExecuteString()
				if err != nil {
					return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
				}
				var games []map[string]any
				err = json.Unmarshal([]byte(rep), &games)
				if err != nil {
					return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
				}

				return jsonResponse(c, http.StatusOK, "", games)
			}
		}

		return jsonResponse(c, http.StatusBadRequest, "Unsupported entity", "")
	})

	e.POST("category", func(c echo.Context) error {
		categoryName := c.FormValue("categoryname")
		isSensitive := c.FormValue("issensitive")

		category := map[string]any{
			"categoryname": categoryName,
			"issensitive":  isSensitive != "",
		}
		_, _, err := client.From("Category").Insert(category, false, "", "", "").ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		return jsonResponse(c, http.StatusOK, "", "")
	})

	e.POST("payment", func(c echo.Context) error {
		paymentType := c.FormValue("type")
		information := c.FormValue("information")

		payment := map[string]string{
			"type":        paymentType,
			"information": information,
		}
		_, _, err := client.From("PaymentMethod").Insert(payment, false, "", "", "").ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		return jsonResponse(c, http.StatusOK, "", "")
	})

	e.POST("publisher", func(c echo.Context) error {
		userID := c.FormValue("userid")
		paymentMethodID := c.FormValue("paymentmethodid")
		description := c.FormValue("description")

		publisher := map[string]string{
			"publisherid":     userID,
			"paymentmethodid": paymentMethodID,
			"description":     description,
		}
		_, _, err := client.From("Publisher").Insert(publisher, false, "", "", "").ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		return jsonResponse(c, http.StatusOK, "", "")
	})
	e.GET("/publisher/:id", func(c echo.Context) error {
		publisherid := c.Param("id")

		rep, _, err := client.From("Publisher").Select("description, Game(*)", "", false).Eq("publisherid", publisherid).Single().ExecuteString()
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, err.Error(), "")
		}

		var user map[string]any
		err = json.Unmarshal([]byte(rep), &user)
		if err != nil {
			return jsonResponse(c, http.StatusBadRequest, "Invalid publisherid" /*err.Error()*/, "")
		}
		return jsonResponse(c, http.StatusOK, "", user)
	})
	e.PATCH("/publisher/:id", func(c echo.Context) error {
		return jsonResponse(c, http.StatusBadRequest, "Unsupported request", "")
	})

	e.Logger.Fatal(e.Start(":1323"))
}
