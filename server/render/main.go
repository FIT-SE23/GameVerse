package main

import (
	"fmt"
	"net/http"
	"runtime"

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
	supabaseURL := "https://vvarlrikusfwrlxshmdj.supabase.co"
	supabaseKEY := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2YXJscmlrdXNmd3JseHNobWRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAxNzU3OTIsImV4cCI6MjA2NTc1MTc5Mn0.aAqTNT13eh1nDTlRRUd_Nnf2tFwuwSrIBMj1iSiLgjg"
	client, err := supabase.NewClient(supabaseURL, supabaseKEY, nil)
	if err != nil {
		fmt.Println("cannot initalize client", err)
		return
	}

	bucketId := "root"

	e := echo.New()

	e.POST("/login", func(c echo.Context) error {
		return login(c, client)
	})

	e.POST("/register", func(c echo.Context) error {
		return addUser(c, client)
	})

	e.GET("/user/:id", func(c echo.Context) error {
		return getUser(c, client)
	})
	e.PATCH("/user/:id", func(c echo.Context) error {
		return jsonResponse(c, http.StatusBadRequest, "Unsupported request", "")
	})
	e.GET("/user/:id/library", func(c echo.Context) error {
		userid := c.Param("id")
		return getGamesWithStatus(c, client, userid, "In library")
	})
	e.GET("/user/:id/wishlist", func(c echo.Context) error {
		userid := c.Param("id")
		return getGamesWithStatus(c, client, userid, "In wishlist")
	})
	e.GET("/user/:id/post", func(c echo.Context) error {
		userid := c.Param("id")
		return getOwnedPost(c, client, userid)
	})
	e.POST("/user/cart", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}
		return getGamesWithStatus(c, client, userid, "In cart")
	})

	e.POST("/addgameto", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		status := c.FormValue("status")
		if status != "In library" && status != "In wishlist" && status != "In cart" {
			return jsonResponse(c, http.StatusBadRequest, "Allow add games to library/wishlist/cart only", "")
		}

		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": status,
		}

		return addGameWithStatus(c, client, userGame)
	})

	e.POST("/removegamefrom", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		status := c.FormValue("status")
		if status != "In wishlist" && status != "In cart" {
			return jsonResponse(c, http.StatusBadRequest, "Allow remove games from wishlist/cart only", "")
		}

		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": status,
		}

		return removeGameWithStatus(c, client, userGame)
	})

	e.POST("/game", func(c echo.Context) error {
		return addGame(c, client, bucketId)
	})

	e.GET("/game/:id", func(c echo.Context) error {
		return getGame(c, client)
	})
	e.PATCH("/game/:id", func(c echo.Context) error {
		return updateGame(c, client, bucketId)
	})

	e.GET("/search", func(c echo.Context) error {
		entity := c.QueryParam("entity")

		switch entity {
		case "user":
			{
				return searchUsers(c, client)
			}
		case "game":
			{
				return searchGames(c, client)
			}
		case "post":
			{
				return searchPosts(c, client)
			}
		}

		return jsonResponse(c, http.StatusBadRequest, "Unsupported entity", "")
	})

	e.POST("/category", func(c echo.Context) error {
		return addCategory(c, client)
	})

	e.POST("/payment", func(c echo.Context) error {
		return addPaymentMethod(c, client)
	})

	e.POST("/publisher", func(c echo.Context) error {
		return addPublisher(c, client)
	})
	e.GET("/publisher/:id", func(c echo.Context) error {
		return getPublisher(c, client)
	})
	e.PATCH("/publisher/:id", func(c echo.Context) error {
		return updatePublisher(c, client)
	})

	e.POST("/paypal/create", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return createPaypalReceipt(c, client, userid)
	})
	e.GET("/paypal/cancel", func(c echo.Context) error {
		return c.String(http.StatusOK, "No")
	})
	e.GET("/paypal/return", func(c echo.Context) error {
		return checkoutPaypal(c, client)
	})

	e.POST("/vnpay/create", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return createVnpayReceipt(c, client, userid)
	})
	e.GET("/vnpay/return", func(c echo.Context) error {
		return checkoutVnpay(c, client)
	})

	e.POST("/recommend/game", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return recommendGame(c, client, userid)
	})

	e.POST("/post", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return addPost(c, client, userid)
	})

	e.GET("/post/:id", func(c echo.Context) error {
		return getPost(c, client)
	})

	e.PATCH("/post/:id", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return updatePost(c, client, userid)
	})

	e.POST("/recommend/post", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return recommendPost(c, client, userid)
	})

	e.DELETE("/post/:id", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return deletePost(c, client, userid)
	})

	e.GET("/post/:id/comment", func(c echo.Context) error {
		postid := c.Param("id")
		return listComments(c, client, postid)
	})

	e.POST("/comment", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return addComment(c, client, userid)
	})

	e.GET("/comment/:id", func(c echo.Context) error {
		return getComment(c, client)
	})

	e.PATCH("/comment/:id", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return updateComment(c, client, userid)
	})

	e.POST("/recommend/comment", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return recommendComment(c, client, userid)
	})

	e.DELETE("/comment/:id", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return deleteComment(c, client, userid)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
