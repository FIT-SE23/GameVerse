import "package:gameverse_server/controller/checkout.dart";
import "package:gameverse_server/controller/comment.dart";
import "package:gameverse_server/controller/game.dart";
import "package:gameverse_server/controller/user.dart";
import "package:gameverse_server/controller/publisher.dart";
import "package:gameverse_server/controller/payment.dart";
import "package:gameverse_server/controller/post.dart";

void main() async {
  if (false) {
    print(await addUser("idontknow", "helloworld@gmail.com", "nooneknow"));
  }

  if (false) {
    print(await addPaymentMethod("Banking", "BIDV"));
    print(await addPaymentMethod("Banking", "AngryBank"));
  }

  // if (false) {
  //   print(
  //     await addPublisher(
  //       "d8915c91-71e6-4a45-84de-a12d0256ffc2",
  //       "a2f4772b-38ac-4fe2-b5a6-bead806c1221",
  //       "We love gaming!!!",
  //     ),
  //   );
  // }

  if (false) {
    print(await addCategory("Horror", true));
    print(await addCategory("FPS", false));
    print(await addCategory("Open World", false));
    print(await addCategory("Indie", false));
  }

  // if (false) {
  //   final resp = await login("gamingizmylife@gmail.com", "noobmaster");
  //   final token = resp.data["token"].toString();
  //   print(
  //     await addGame(
  //       "Bearer " + token,
  //       "Gamer Simulator 2",
  //       "Tiếp nối câu chuyện của giả lập cuộc sống người chơi game",
  //       42000.0,
  //       ["/home/nullgus/Downloads/raylib/lib/x86_64/libraylib.a"],
  //       ["/home/nullgus/Downloads/raylib/logo/raylib_128x128.png"],
  //       ["/home/nullgus/Downloads/raylib/logo/raylib_1024x1024.png"],
  //       ["/home/nullgus/Code/win32/Calendar/calendar.exe"],
  //       "Indie,Open World",
  //     ),
  //   );
  // }
  
  if (false) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data.toString();

    print(
      await addGameWithStatus(
        token,
        "60ce4bab-c05d-4d71-9f4a-028f545c6cb0",
        "In cart",
      ),
    );
    print(await listGamesInCart(token));
    print(
      await listGamesInLibraryOrWishlist(
        "d8915c91-71e6-4a45-84de-a12d0256ffc2",
        "In library",
      ),
    );
  }

  if (false) {
    print(
      await updateGame(
        gameId: '60ce4bab-c05d-4d71-9f4a-028f545c6cb0',
        name: 'Medieval Village 2',
        description:
            'Step into the heart of a medieval world where you build, manage, and protect your own village against evil creatures',
        categories: 'Indie, Open World',
        resourceids: ['c0313600-7205-40ed-857c-72136cbc80f0'],
        media: [
          'C:/Users/TPComputer/Pictures/brightness.png',
          "D:/SE/resource/game/MedivalV/OBJ/WindowShutters_Wide_Flat_Open.obj",
        ],
      ),
    );
  }

  if (false) {
    print(
      await updatePublisher(
        publisherId: 'd8915c91-71e6-4a45-84de-a12d0256ffc2',
        description: "We hate game",
      ),
    );
  }

  // if (false) {
  //   print(await listGames("Gamer Simulator 2", "recommend", 0, 1));
  // }

  if (false) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data["token"].toString();
    final userid = resp.data["userid"].toString();
    print(token + "\n" + userid);
    print(await recommendGame(token, "60ce4bab-c05d-4d71-9f4a-028f545c6cb0"));
  }

  if (false) {
    print(await getGame("", "60ce4bab-c05d-4d71-9f4a-028f545c6cb0"));
  }

  if (false) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    print(await getUser(resp.data["userid"].toString()));
    final token = resp.data["token"].toString();
    print(await createVnpayReceipt(token));
  }

  if (false) {
    final resp = await listUser("");
    print(resp);
  }

  if (false) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data["token"].toString();
    print(await createVnpayReceipt(token));
  }

  if (false) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data["token"].toString();
    print(await downloadGame(token, "60ce4bab-c05d-4d71-9f4a-028f545c6cb0"));
  }

  if (true) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data["token"].toString();
    print(await addComment(token, "1a6de353-8e25-42d0-a486-04f62f78c69c", "hello"));
  }
}
