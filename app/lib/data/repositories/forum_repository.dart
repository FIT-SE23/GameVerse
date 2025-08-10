import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

class ForumRepository {
  
  Future<List<GameModel>> getGamesWithForums() async {
    return _getMockGamesWithForums();
  }

  List<GameModel> _getMockGamesWithForums() {
    return [
      GameModel(
        gameId: '1',
        publisherId: '1',
        name: 'Cyberpunk 2077',
        recommended: 95,
        briefDescription: 'An open-world, action-adventure story set in Night City.',
        description: 'Cyberpunk 2077 is an open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification. You play as V, a mercenary outlaw going after a one-of-a-kind implant that is the key to immortality.',
        requirement: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-3570K or AMD FX-8310, Memory: 8 GB RAM, Graphics: NVIDIA GeForce GTX 780 or AMD Radeon RX 470',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_814c156a6df96984349177d2e5df5b63a65b7321.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_67ba98b7f1dd3c54086b76f7d9dba97f7b19c3f3.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
        ],
        price: 29.99,
        categories: [
          CategoryModel(categoryId: '1', name: 'Action', isSensitive: false),
          CategoryModel(categoryId: '2', name: 'Adventure', isSensitive: false),
          CategoryModel(categoryId: '3', name: 'RPG', isSensitive: false),
        ],
        releaseDate: DateTime(2020, 12, 10),
        isSale: true,
        discountPercent: 50.0,
        saleStartDate: DateTime.now().subtract(const Duration(days: 3)),
        saleEndDate: DateTime.now().add(const Duration(days: 4)),
        isOwned: false,
        isInstalled: false,
        favorite: false,
      ),
      GameModel(
        gameId: '2',
        publisherId: '2',
        name: 'Red Dead Redemption 2',
        recommended: 97,
        briefDescription: 'An epic tale of life in America\'s unforgiving heartland.',
        description: 'Arthur Morgan and the Van der Linde gang are outlaws on the run. With federal agents and the best bounty hunters in the nation massing on their heels, the gang must rob, steal and fight their way across the rugged heartland of America in order to survive.',
        requirement: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-2500K / AMD FX-6300, Memory: 8 GB RAM, Graphics: Nvidia GeForce GTX 770 2GB / AMD Radeon R9 280',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_668dafe477743281eebce2b5b7e8b6a8ebedf9e4.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_2eb12dc29e1c83ba4f1b4df35d73d8b9da1c7e85.jpg',
        ],
        price: 49.99,
        categories: [
          CategoryModel(categoryId: '4', name: 'Action', isSensitive: false),
          CategoryModel(categoryId: '5', name: 'Adventure', isSensitive: false),
          CategoryModel(categoryId: '6', name: 'Open World', isSensitive: false),
        ],
        releaseDate: DateTime(2019, 11, 5),
        isSale: false,
        isOwned: false,
        isInstalled: false,
        favorite: false,
      ),
      GameModel(
        gameId: '3',
        publisherId: '3',
        name: 'The Witcher 3: Wild Hunt',
        recommended: 98,
        briefDescription: 'The most awarded game of a generation is now enhanced for the next!',
        description: 'You are Geralt of Rivia, mercenary monster slayer. Before you stands a war-torn, monster-infested continent you can explore at will. Your current contract? Tracking down Ciri — the Child of Prophecy, a living weapon that can alter the shape of the world.',
        requirement: 'Minimum: OS: 64-bit Windows 10, Processor: Intel CPU Core i5-2500K 3.3GHz / AMD A10-5800K APU, Memory: 6 GB RAM, Graphics: Nvidia GPU GeForce GTX 660 / AMD GPU Radeon HD 7870',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_207e5c8689cea5eeee14d031e9e4a3ad3a80dda8.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_8b7f1e7d7d0b7e4f8e7d4a5c5e4f7e8d9f0a1b2c.jpg',
        ],
        price: 39.99,
        categories: [
          CategoryModel(categoryId: '7', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '8', name: 'Adventure', isSensitive: false),
          CategoryModel(categoryId: '9', name: 'Fantasy', isSensitive: false),
        ],
        releaseDate: DateTime(2015, 5, 19),
        isSale: true,
        discountPercent: 75.0,
        saleStartDate: DateTime.now().subtract(const Duration(days: 1)),
        saleEndDate: DateTime.now().add(const Duration(days: 6)),
        isOwned: false,
        isInstalled: false,
        favorite: false,
      ),
    ];
  }
}