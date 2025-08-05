import "package:gameverse_server/controller/game.dart";
import "package:gameverse_server/controller/user.dart";
import "package:gameverse_server/controller/publisher.dart";
import "package:gameverse_server/controller/payment.dart";

void main() async {
  if (false) {
    print(await addUser("idontknow", "helloworld@gmail.com", "nooneknow"));
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
        ["MediaPath/header_pic2"],
        ["main.exe"],
        "Indie",
      ),
    );
  }
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

  if (false) {
    print(await listGames("Gamer Simulator 2", "recommend"));
  }

  if (false) {
    final resp = await login("gamingizmylife@gmail.com", "noobmaster");
    final token = resp.data["token"].toString();
    final userid = resp.data["userid"].toString();
    print(token + "\n" + userid);
    print(
      await recommendGame(token, "60ce4bab-c05d-4d71-9f4a-028f545c6cb0"),
    );
  }

  if (false) {
    print(await getGame("", "12de500f-9810-4428-b217-d606b6847dac"));
  }
}
