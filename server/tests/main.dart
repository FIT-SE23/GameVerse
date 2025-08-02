import "package:gameverse_server/controller/game.dart";
import "package:gameverse_server/controller/user.dart";
import "package:gameverse_server/controller/publisher.dart";
import "package:gameverse_server/controller/payment.dart";

void main() async {
  if (false) {
    print(
      await addUser("iluvgaming", "gamingizmylife@gmail.com", "noobmaster"),
    );
    print(await addUser("noobmaster", "noobmaster420@gmail.com", "noobmaster"));

    final users = await listUser("");
    print(users);
  }

  if (false) {
    print(await addPaymentMethod("Banking", "BIDV"));
    print(await addPaymentMethod("Banking", "AngryBank"));
  }

  if (false) {
    print(
      await addPublisher(
        "d8915c91-71e6-4a45-84de-a12d0256ffc2",
        "0cabe94e-3eeb-4d78-b144-69d09b8bd445",
        "We love gaming!!!",
      ),
    );
  }

  if (false) {
    print(await addCategory("Horror", true));
    print(await addCategory("FPS", false));
    print(await addCategory("Open World", false));
    print(await addCategory("Indie", false));
  }

  if (false) {
    print(
      await addGame(
        "d8915c91-71e6-4a45-84de-a12d0256ffc2",
        "Gamer Simulator",
        "Giả lập cuộc sống của người chơi trò chơi",
        [
          "Absolutely/path/file1",
          "Absolutely/path/file2",
          "Absolutely/path/file3",
        ],
        ["MediaPath/pic1", "MediaPath/pic2"],
        ["main.exe"],
        "Indie",
      ),
    );
  }
  if (true) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data.toString();

    print(
      await addGameWithStatus(
        token,
        "d8915c91-71e6-4a45-84de-a12d0256ffc2",
        "60ce4bab-c05d-4d71-9f4a-028f545c6cb0",
        "In cart",
      ),
    );
    print(await listGamesInCart(token, "d8915c91-71e6-4a45-84de-a12d0256ffc2"));
    print(
      await listGamesInLibraryOrWishlist(
        "d8915c91-71e6-4a45-84de-a12d0256ffc2",
        "In library",
      ),
    );
  }
}
