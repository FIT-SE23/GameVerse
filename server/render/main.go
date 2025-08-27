package main

import (
	"fmt"
	"net/http"
	"os"
	"render/config"
	"render/controller"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/supabase-community/supabase-go"
)

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
		return controller.Login(c, client)
	})

	e.POST("/register", func(c echo.Context) error {
		return controller.AddUser(c, client)
	})

	e.GET("/recover", func(c echo.Context) error {
		return controller.RecoverPassword(c, client)
	})
	e.GET("/verify", func(c echo.Context) error {
		user := controller.VerifyPasswordResetToken(c, client)
		if user == nil {
			return config.JsonResponse(c, http.StatusBadRequest, "Failed to verify otp. Try again", "")
		}

		return config.JsonResponse(c, http.StatusOK, "", user)
	})

	e.GET("/user/:id", func(c echo.Context) error {
		return controller.GetUser(c, client)
	})
	e.PATCH("/user/:id", func(c echo.Context) error {
		return controller.UpdateUser(c, client)
	})
	e.GET("/user/:id/library", func(c echo.Context) error {
		userid := c.Param("id")
		return controller.GetGamesWithStatus(c, client, userid, "In library")
	})
	e.GET("/user/:id/wishlist", func(c echo.Context) error {
		userid := c.Param("id")
		return controller.GetGamesWithStatus(c, client, userid, "In wishlist")
	})
	e.GET("/user/:id/post", func(c echo.Context) error {
		userid := c.Param("id")
		return controller.GetOwnedPost(c, client, userid)
	})
	e.POST("/user/cart", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}
		return controller.GetGamesWithStatus(c, client, userid, "In cart")
	})

	e.POST("/user/playtime", func(c echo.Context) error {
		return controller.AddPlaytimeData(c, client)
	})
	e.GET("/user/playtime", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}
		return controller.GetPlaytimeData(c, client, userid)
	})

	e.POST("/addgameto", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		status := c.FormValue("status")
		if status != "In library" && status != "In wishlist" && status != "In cart" {
			return config.JsonResponse(c, http.StatusBadRequest, "Allow add games to library/wishlist/cart only", "")
		}

		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": status,
		}

		return controller.AddGameWithStatus(c, client, userGame)
	})

	e.POST("/removegamefrom", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		status := c.FormValue("status")
		if status != "In wishlist" && status != "In cart" {
			return config.JsonResponse(c, http.StatusBadRequest, "Allow remove games from wishlist/cart only", "")
		}

		gameid := c.FormValue("gameid")
		userGame := map[string]string{
			"userid": userid,
			"gameid": gameid,
			"status": status,
		}

		return controller.RemoveGameWithStatus(c, client, userGame)
	})

	e.POST("/game", func(c echo.Context) error {
		return controller.AddGame(c, client, bucketId)
	})
	e.GET("/game/:id", func(c echo.Context) error {
		return controller.GetGame(c, client)
	})
	e.PATCH("/game/:id", func(c echo.Context) error {
		return controller.UpdateGame(c, client, bucketId)
	})
	e.POST("/game/requests", func(c echo.Context) error {
		return controller.GetGameRequests(c, client)
	})
	e.POST("/game/verify", func(c echo.Context) error {
		return controller.VerifyGame(c, client)
	})
	e.POST("/download/game", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}

		return controller.DownloadGame(c, client, userid)
	})

	e.GET("/search", func(c echo.Context) error {
		entity := c.QueryParam("entity")

		switch entity {
		case "user":
			{
				return controller.SearchUsers(c, client)
			}
		case "game":
			{
				return controller.SearchGames(c, client)
			}
		case "post":
			{
				return controller.SearchPosts(c, client)
			}
		}

		return config.JsonResponse(c, http.StatusBadRequest, "Unsupported entity", "")
	})

	e.POST("/category", func(c echo.Context) error {
		return controller.AddCategory(c, client)
	})
	e.GET("/categories", func(c echo.Context) error {
		return controller.GetCategories(c, client)
	})

	e.POST("/payment", func(c echo.Context) error {
		return controller.AddPaymentMethod(c, client)
	})
	e.GET("/payment", func(c echo.Context) error {
		return controller.GetPaymentMethods(c, client)
	})

	e.POST("/publisher", func(c echo.Context) error {
		return controller.AddPublisher(c, client)
	})
	e.GET("/publisher/:id", func(c echo.Context) error {
		return controller.GetPublisher(c, client)
	})
	e.PATCH("/publisher/:id", func(c echo.Context) error {
		return controller.UpdatePublisher(c, client)
	})
	e.POST("/publisher/requests", func(c echo.Context) error {
		return controller.GetPublisherRequests(c, client)
	})
	e.POST("/publisher/verify", func(c echo.Context) error {
		return controller.VerifyPublisher(c, client)
	})

	e.POST("/transactions", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return controller.GetTransactions(c, client, userid)
	})
	e.POST("/paypal/create", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			// TODO: Redirect to login page
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return controller.CreatePaypalReceipt(c, client, userid)
	})
	e.GET("/paypal/cancel", func(c echo.Context) error {
		return c.String(http.StatusOK, "No")
	})
	e.GET("/paypal/return", func(c echo.Context) error {
		code, msg := controller.CheckoutVnpay(c, client)
		if code == http.StatusBadRequest {
			return c.HTML(code, "Invalid request")
		} else if code == http.StatusInternalServerError {
			return c.HTML(code, "Internal server error")
		}

		msg["paymentmethod"] = "Paypal"
		return c.HTML(http.StatusOK, controller.GenCheckoutPage(msg))
	})

	e.POST("/vnpay/create", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return config.JsonResponse(c, http.StatusUnauthorized, "Please login", "")
		}

		return controller.CreateVnpayReceipt(c, client, userid)
	})
	e.GET("/vnpay/return", func(c echo.Context) error {
		code, msg := controller.CheckoutVnpay(c, client)
		if code == http.StatusBadRequest {
			return c.HTML(code, "Invalid request")
		} else if code == http.StatusInternalServerError {
			return c.HTML(code, "Internal server error")
		}

		msg["paymentmethod"] = "VNPay"
		return c.HTML(http.StatusOK, controller.GenCheckoutPage(msg))
	})

	e.POST("/recommend/game", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.RecommendGame(c, client, userid)
	})

	e.GET("/recommend/game/:id", func(c echo.Context) error {
		gameid := c.Param("id")
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.IsRecommended(c, client, userid, gameid)
	})

	e.POST("/post", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.AddPost(c, client, userid)
	})

	e.GET("/post/:id", func(c echo.Context) error {
		return controller.GetPost(c, client)
	})

	e.PATCH("/post/:id", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.UpdatePost(c, client, userid)
	})

	e.POST("/recommend/post", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.RecommendPost(c, client, userid)
	})

	e.GET("/recommend/post/:id", func(c echo.Context) error {
		postid := c.Param("id")
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.IsPostRecommended(c, client, userid, postid)
	})

	e.DELETE("/post/:id", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.DeletePost(c, client, userid)
	})

	e.GET("/post/:id/comment", func(c echo.Context) error {
		postid := c.Param("id")
		return controller.ListComments(c, client, postid)
	})

	e.POST("/comment", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.AddComment(c, client, userid)
	})

	e.GET("/comment/:id", func(c echo.Context) error {
		return controller.GetComment(c, client)
	})

	e.PATCH("/comment/:id", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.UpdateComment(c, client, userid)
	})

	e.POST("/recommend/comment", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.RecommendComment(c, client, userid)
	})

	e.GET("/recommend/comment/:id", func(c echo.Context) error {
		commentid := c.Param("id")
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.IsCommentRecommended(c, client, userid, commentid)
	})

	e.DELETE("/comment/:id", func(c echo.Context) error {
		userid, err := controller.VerifyUserToken(c)
		if err != nil {
			return err
		}
		return controller.DeleteComment(c, client, userid)
	})

	e.GET("/forum", func(c echo.Context) error {
		return controller.GetAllForums(c, client)
	})
	e.GET("/forum/:id", func(c echo.Context) error {
		return controller.GetForum(c, client)
	})

	e.POST("/verify-oauth-token", func(c echo.Context) error {
		return controller.VerifyOAuthToken(c, client)
	})
	e.POST("/verify-user-token", func(c echo.Context) error {
		return controller.VerifyToken(c)
	})

	e.POST("/messages/game", func(c echo.Context) error {
		return controller.AddGameMessage(c, client)
	})
	e.GET("/messages/game", func(c echo.Context) error {
		return controller.GetGameMessage(c, client)
	})
	e.POST("/messages/publisher", func(c echo.Context) error {
		return controller.AddPublisherMessage(c, client)
	})
	e.GET("/messages/publisher", func(c echo.Context) error {
		return controller.GetPublisherMessage(c, client)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
