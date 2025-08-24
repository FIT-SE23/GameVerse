package main

import (
	"fmt"
	"net/http"
	"os"
	"runtime"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
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
	e.Use(middleware.CORS())
	e.Static("/static", "assets")

	e.POST("/login", func(c echo.Context) error {
		return login(c, client)
	})

	e.POST("/register", func(c echo.Context) error {
		return addUser(c, client)
	})

	e.GET("/recover", func(c echo.Context) error {
		return recoverPassword(c, client)
	})
	e.GET("/verify", func(c echo.Context) error {
		user := verifyPasswordResetToken(c, client)
		if user == nil {
			return jsonResponse(c, http.StatusBadRequest, "Failed to verify otp. Try again", "")
		}

		return jsonResponse(c, http.StatusOK, "", user)
	})

	e.GET("/user/:id", func(c echo.Context) error {
		return getUser(c, client)
	})
	e.PATCH("/user/:id", func(c echo.Context) error {
		return updateUser(c, client)
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

	e.POST("/user/playtime", func(c echo.Context) error {
		return addPlaytimeData(c, client)
	})
	e.GET("/user/playtime", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}
		return getPlaytimeData(c, client, userid)
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
	e.POST("/game/requests", func(c echo.Context) error {
		return getGameRequests(c, client)
	})
	e.POST("/game/verify", func(c echo.Context) error {
		return verifyGame(c, client)
	})
	e.POST("/download/game", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}

		return downloadGame(c, client, userid)
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
	e.GET("/categories", func(c echo.Context) error {
		return getCategories(c, client)
	})

	e.POST("/payment", func(c echo.Context) error {
		return addPaymentMethod(c, client)
	})
	e.GET("/payment", func(c echo.Context) error {
		return getPaymentMethods(c, client)
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
	e.POST("/publisher/requests", func(c echo.Context) error {
		return getPublisherRequests(c, client)
	})
	e.POST("/publisher/verify", func(c echo.Context) error {
		return verifyPublisher(c, client)
	})

	e.POST("/transactions", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return getTransactions(c, client, userid)
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
		code, msg := checkoutVnpay(c, client)
		if code == http.StatusBadRequest {
			return c.HTML(code, "Invalid request")
		} else if code == http.StatusInternalServerError {
			return c.HTML(code, "Internal server error")
		}

		msg["paymentmethod"] = "Paypal"
		return c.HTML(http.StatusOK, genCheckoutPage(msg))
	})

	e.POST("/vnpay/create", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return jsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return createVnpayReceipt(c, client, userid)
	})
	e.GET("/vnpay/return", func(c echo.Context) error {
		code, msg := checkoutVnpay(c, client)
		if code == http.StatusBadRequest {
			return c.HTML(code, "Invalid request")
		} else if code == http.StatusInternalServerError {
			return c.HTML(code, "Internal server error")
		}

		msg["paymentmethod"] = "VNPay"
		return c.HTML(http.StatusOK, genCheckoutPage(msg))
	})

	e.POST("/recommend/game", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return recommendGame(c, client, userid)
	})

	e.GET("/recommend/game/:id", func(c echo.Context) error {
		gameid := c.Param("id")
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return isRecommended(c, client, userid, gameid)
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

	e.GET("/recommend/post/:id", func(c echo.Context) error {
		postid := c.Param("id")
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return isPostRecommended(c, client, userid, postid)
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

	e.GET("/recommend/comment/:id", func(c echo.Context) error {
		commentid := c.Param("id")
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return isCommentRecommended(c, client, userid, commentid)
	})

	e.DELETE("/comment/:id", func(c echo.Context) error {
		userid, err := verifyUserToken(c)
		if err != nil {
			return err
		}
		return deleteComment(c, client, userid)
	})

	e.GET("/forum", func(c echo.Context) error {
		return getAllForums(c, client)
	})
	e.GET("/forum/:id", func(c echo.Context) error {
		return getForum(c, client)
	})

	e.POST("/verify-oauth-token", func(c echo.Context) error {
		return verifyOAuthToken(c, client)
	})
	e.POST("/verify-user-token", func(c echo.Context) error {
		return verifyToken(c)
	})

	e.POST("/messages/game", func(c echo.Context) error {
		return addGameMessage(c, client)
	})
	e.GET("/messages/game", func(c echo.Context) error {
		return getGameMessage(c, client)
	})
	e.POST("/messages/publisher", func(c echo.Context) error {
		return addPublisherMessage(c, client)
	})
	e.GET("/messages/publisher", func(c echo.Context) error {
		return getPublisherMessage(c, client)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
