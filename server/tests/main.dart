import "dart:convert";

import "package:crypto/crypto.dart";
import "package:gameverse_server/controller/game.dart";
import "package:gameverse_server/controller/user.dart";
import "package:gameverse_server/controller/publisher.dart";
import "package:gameverse_server/controller/payment.dart";
import "package:http/http.dart" as http;

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
        "Indie",
      ),
    );
  }
}
