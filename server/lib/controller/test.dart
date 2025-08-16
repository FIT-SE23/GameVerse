import 'game.dart';

void main() async {
  // print(await getGame("", "60ce4bab-c05d-4d71-9f4a-028f545c6cb0"));
  // print(await listGames('a', 'price', 0, 10, 'Indie'));
  print(await listGames('g', 'popularity', 0, 10, 'Indie'));
  // await listGames('', 'popularity', 0, 10, 'Indie');
}