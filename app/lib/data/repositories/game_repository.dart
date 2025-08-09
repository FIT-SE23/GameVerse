import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

class GameRepository {
  final http.Client client;

  void _initializeMockData() {
    _allGames = [
      ..._getMockFeaturedGames(),
      ..._getMockOwnedGames(),
      ..._getMockAdditionalGames(),
    ];
  }

  List<GameModel> _allGames = [];
  List<GameModel> get allGames => _allGames;

  GameRepository({http.Client? httpClient}) : client = httpClient ?? http.Client() {
    _initializeMockData();
  }
  
  Future<List<GameModel>> searchGames(List<String> name) async {
    return _allGames;
  }

  Future<List<GameModel>> getFeaturedGames() async {
    return _getMockFeaturedGames();
  }

  Future<List<GameModel>> getOwnedGames(String userId) async {
    return _getMockOwnedGames();
  }

  Future<GameModel?> getGameDetails(String gameId) async {

    final result = _allGames.firstWhere(
      (game) => game.gameId == gameId,
    );
    
    if (result.gameId == gameId) {
      return result;
    }

    return null;
  }

  // Mock Data Methods
  List<GameModel> _getMockFeaturedGames() {
    return [
      GameModel(
        gameId: '1',
        publisherId: '1',
        name: 'Cyberpunk 2077',
        recommended: 95,
        briefDescription: 'An open-world, action-adventure story set in Night City.',
        description: 'Cyberpunk 2077 is an open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification. You play as V, a mercenary outlaw going after a one-of-a-kind implant that is the key to immortality.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-3570K or AMD FX-8310, Memory: 8 GB RAM, Graphics: NVIDIA GeForce GTX 780 or AMD Radeon RX 470',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
        media: [
          'https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1091500/ss_2f649b68d579bf87011487d29bc4ccbfdd97d34f.1920x1080.jpg?t=1753355628',
          'https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1091500/ss_0e64170751e1ae20ff8fdb7001a8892fd48260e7.1920x1080.jpg?t=1753355628',
          'https://shared.akamai.steamstatic.com/store_item_assets/steam/apps/1091500/ss_af2804aa4bf35d4251043744412ce3b359a125ef.1920x1080.jpg?t=1753355628',
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
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-2500K / AMD FX-6300, Memory: 8 GB RAM, Graphics: Nvidia GeForce GTX 770 2GB / AMD Radeon R9 280',
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
        requirements: 'Minimum: OS: 64-bit Windows 10, Processor: Intel CPU Core i5-2500K 3.3GHz / AMD A10-5800K APU, Memory: 6 GB RAM, Graphics: Nvidia GPU GeForce GTX 660 / AMD GPU Radeon HD 7870',
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
      GameModel(
        gameId: '4',
        publisherId: '4',
        name: 'Grand Theft Auto V',
        recommended: 94,
        briefDescription: 'Grand Theft Auto V for PC offers players the option to explore the award-winning world of Los Santos and Blaine County.',
        description: 'When a young street hustler, a retired bank robber and a terrifying psychopath find themselves entangled with some of the most frightening and deranged elements of the criminal underworld, the U.S. government and the entertainment industry, they must pull off a series of dangerous heists to survive.',
        requirements: 'Minimum: OS: Windows 10 64 Bit, Processor: Intel Core 2 Quad CPU Q6600 @ 2.40GHz (4 CPUs) / AMD Phenom 9850 Quad-Core Processor (4 CPUs) @ 2.5GHz, Memory: 4 GB RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/271590/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/271590/ss_34c535d3a8f83a8ccaae7e15a0f7f810c1f32d2d.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/271590/ss_6c8ae5e0c55b5b0b4f6e7c8d9f0a1b2c3d4e5f6g.jpg',
        ],
        price: 59.99,
        categories: [
          CategoryModel(categoryId: '10', name: 'Action', isSensitive: false),
          CategoryModel(categoryId: '11', name: 'Adventure', isSensitive: false),
          CategoryModel(categoryId: '12', name: 'Crime', isSensitive: true),
        ],
        releaseDate: DateTime(2015, 4, 14),
        isSale: false,
        isOwned: false,
        isInstalled: false,
        favorite: false,
      ),
    ];
  }

  List<GameModel> _getMockOwnedGames() {
    return [
      GameModel(
        gameId: '5',
        publisherId: '3',
        name: 'Dota 2',
        recommended: 92,
        briefDescription: 'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes.',
        description: 'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes. And no matter if it\'s their 10th hour of play or 1,000th, there\'s always something new to discover. With regular updates that ensure a constant evolution of gameplay, features, and heroes, Dota 2 has taken on a life of its own.',
        requirements: 'Minimum: OS: Windows 10, Processor: Dual core from Intel or AMD at 2.8 GHz, Memory: 4 GB RAM, Graphics: nVidia GeForce 8600/9600GT, ATI/AMD Radeon HD2600/3600',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_d830cdf96919729c2b1d81876cb1ba8e7b1e7c25.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_bb5bf1d27ae13e8ef9fe9b9e4cdfba0e0aac2b1a.jpg',
        ],
        price: 0.0, // Free to play
        categories: [
          CategoryModel(categoryId: '13', name: 'MOBA', isSensitive: false),
          CategoryModel(categoryId: '14', name: 'Strategy', isSensitive: false),
        ],
        releaseDate: DateTime(2013, 7, 9),
        isSale: false,
        isOwned: true,
        isInstalled: true,
        favorite: true,
        playtimeHours: 156.7,
      ),
      GameModel(
        gameId: '6',
        publisherId: '2',
        name: 'Counter-Strike 2',
        recommended: 89,
        briefDescription: 'Counter-Strike 2 marks the beginning of a new chapter in the legendary FPS series.',
        description: 'For over two decades, Counter-Strike has offered an elite competitive experience, one shaped by millions of players from across the globe. And now the next chapter in the CS story is about to begin. This is Counter-Strike 2.',
        requirements: 'Minimum: OS: Windows 10, Processor: 4 hardware CPU threads - Intel® Core™ i5 750 or higher, Memory: 8 GB RAM, Graphics: Video card must be 1 GB or more',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/730/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_34309c49a2bb50e6b8a64454c632c5a289c8fd10.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_8db10c45158dd09fde9bfbcc8c866b31de1a14d5.jpg',
        ],
        price: 0.0, // Free to play
        categories: [
          CategoryModel(categoryId: '15', name: 'FPS', isSensitive: false),
          CategoryModel(categoryId: '16', name: 'Multiplayer', isSensitive: false),
        ],
        releaseDate: DateTime(2023, 9, 27),
        isSale: false,
        isOwned: true,
        isInstalled: true,
        favorite: false,
        playtimeHours: 234.2,
      ),
      GameModel(
        gameId: '7',
        publisherId: '4',
        name: 'Team Fortress 2',
        recommended: 88,
        briefDescription: 'Nine distinct classes provide a broad range of tactical abilities and personalities.',
        description: 'Nine distinct classes provide a broad range of tactical abilities and personalities. Constantly updated with new game modes, maps, equipment and, most importantly, hats!',
        requirements: 'Minimum: OS: Windows® 7 (32/64-bit)/Vista/XP, Processor: 1.7 GHz Processor or better, Memory: 512 MB RAM, Graphics: DirectX® 8.1 level Graphics Card',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/440/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_a1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_b2d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2.jpg',
        ],
        price: 0.0, // Free to play
        categories: [
          CategoryModel(categoryId: '17', name: 'FPS', isSensitive: false),
          CategoryModel(categoryId: '18', name: 'Multiplayer', isSensitive: false),
        ],
        releaseDate: DateTime(2007, 10, 10),
        isSale: false,
        isOwned: true,
        isInstalled: false,
        favorite: false,
        playtimeHours: 67.8,

        binaries: [
          'https://vvarlrikusfwrlxshmdj.supabase.co/storage/v1/object/sign/root/d8915c91-71e6-4a45-84de-a12d0256ffc2/res/2025-08-09T04-17-06Zcalendar.exe?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83MDBiYmQ2YS00ZjkzLTRjNTMtYjYzMS03ZTQ2NTJmYTQ1N2MiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJyb290L2Q4OTE1YzkxLTcxZTYtNGE0NS04NGRlLWExMmQwMjU2ZmZjMi9yZXMvMjAyNS0wOC0wOVQwNC0xNy0wNlpjYWxlbmRhci5leGUiLCJpYXQiOjE3NTQ3MTMwMjYsImV4cCI6MTc4NjI0OTAyNn0.S2X9qk57ZQCdjsj6wKMfmG7Jpgow1QoykSncQGXbrR8'
        ],
        exes: [
          'https://vvarlrikusfwrlxshmdj.supabase.co/storage/v1/object/sign/root/d8915c91-71e6-4a45-84de-a12d0256ffc2/res/2025-08-09T04-17-06Zcalendar.exe?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV83MDBiYmQ2YS00ZjkzLTRjNTMtYjYzMS03ZTQ2NTJmYTQ1N2MiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJyb290L2Q4OTE1YzkxLTcxZTYtNGE0NS04NGRlLWExMmQwMjU2ZmZjMi9yZXMvMjAyNS0wOC0wOVQwNC0xNy0wNlpjYWxlbmRhci5leGUiLCJpYXQiOjE3NTQ3MTMwMjYsImV4cCI6MTc4NjI0OTAyNn0.S2X9qk57ZQCdjsj6wKMfmG7Jpgow1QoykSncQGXbrR8'
        ],
      ),
      GameModel(
        gameId: '8',
        publisherId: '5',
        name: 'The Elder Scrolls V: Skyrim',
        recommended: 96,
        briefDescription: 'EPIC FANTASY REBORN - The next chapter in the highly anticipated Elder Scrolls saga.',
        description: 'EPIC FANTASY REBORN The next chapter in the highly anticipated Elder Scrolls saga arrives from the makers of the 2006 and 2008 Games of the Year, Bethesda Game Studios. Skyrim reimagines and revolutionizes the open-world fantasy epic.',
        requirements: 'Minimum: OS: Windows 7/Vista/XP PC (32 or 64 bit), Processor: Dual Core 2.0GHz or equivalent processor, Memory: 2GB System RAM, Graphics: Direct X 9.0c compliant video card with 512 MB of RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/72850/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2f2.jpg',
        ],
        price: 19.99,
        categories: [
          CategoryModel(categoryId: '19', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '20', name: 'Open World', isSensitive: false),
          CategoryModel(categoryId: '21', name: 'Fantasy', isSensitive: false),
        ],
        releaseDate: DateTime(2011, 11, 11),
        isSale: false,
        isOwned: true,
        isInstalled: true,
        favorite: true,
        playtimeHours: 289.4,
      ),
    ];
  }

  List<GameModel> _getMockAdditionalGames() {
    return [
      GameModel(
        gameId: '9',
        publisherId: '6',
        name: 'Baldur\'s Gate 3',
        recommended: 96,
        briefDescription: 'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal.',
        description: 'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal, sacrifice and survival, and the lure of absolute power. Mysterious abilities are awakening inside you, drawn from a mind flayer parasite planted in your brain.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel I5 4690 / AMD FX 8350, Memory: 8 GB RAM, Graphics: Nvidia GTX 970 / RX 480 (4GB+ of VRAM)',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1086940/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1086940/ss_e1f1e1f1e1f1e1f1e1f1e1f1e1f1e1f1e1f1e1f1.jpg',
        ],
        price: 59.99,
        categories: [
          CategoryModel(categoryId: '22', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '23', name: 'Adventure', isSensitive: false),
          CategoryModel(categoryId: '24', name: 'Fantasy', isSensitive: false),
        ],
        releaseDate: DateTime(2023, 8, 3),
        isSale: false,
        isOwned: false,
        isInstalled: false,
        favorite: false,
      ),
      GameModel(
        gameId: '10',
        publisherId: '7',
        name: 'Call of Duty®: Modern Warfare® III',
        recommended: 82,
        briefDescription: 'In the direct sequel to the record-breaking Call of Duty®: Modern Warfare® II.',
        description: 'In the direct sequel to the record-breaking Call of Duty®: Modern Warfare® II, Captain Price and Task Force 141 face off against the ultimate threat.',
        requirements: 'Minimum: OS: Windows® 10 64 Bit (latest update), Processor: AMD Ryzen™ 5 1400 or Intel® Core™ i5-6600K, Memory: 8 GB RAM, Graphics: AMD Radeon™ RX 470 or NVIDIA® GeForce® GTX 960',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1938090/header.jpg',
        media: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1938090/ss_f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2.jpg',
        ],
        price: 59.99,
        categories: [
          CategoryModel(categoryId: '25', name: 'FPS', isSensitive: false),
          CategoryModel(categoryId: '26', name: 'Action', isSensitive: false),
          CategoryModel(categoryId: '27', name: 'Multiplayer', isSensitive: false),
        ],
        releaseDate: DateTime(2023, 11, 10),
        isSale: false,
        isOwned: false,
        isInstalled: false,
        favorite: false,
      ),
    ];
  }

  // Set folder path for game installation
  void setGameInstallationPath(String gameId, String path) {
    final gameIndex = _allGames.indexWhere((game) => game.gameId == gameId);
    if (gameIndex != -1) {
      final game = _allGames[gameIndex];
      _allGames[gameIndex] = game.copyWith(path: path);
    }
  }

  // Check if the game is isInstalled, if yes, set the isInstalled field to true
  Future<bool> setGameInstallation(String gameId) async {
    final gameIndex = _allGames.indexWhere((game) => game.gameId == gameId);
    // debugPrint('Checking game: ${_allGames[gameIndex]}');
    if (gameIndex != -1 && _allGames[gameIndex].path != null) {
      if (await checkGameInstallation(_allGames[gameIndex].path!)) {
        final game = _allGames[gameIndex];
        _allGames[gameIndex] = game.copyWith(isInstalled: true);
        return true;
      } else {
        final game = _allGames[gameIndex];
        _allGames[gameIndex] = game.copyWith(
          isInstalled: false,
          path: null,
        );
      }
    }
    return false;
  }

  
  Future<bool> checkGameInstallation(String gamePath) async {
    final gameDir = Directory(gamePath);
    if (!await gameDir.exists()) return false;

    await for (final entity in gameDir.list(recursive: true)) {
      if (entity is File) {
        final extension = path.extension(entity.path).toLowerCase();
        if (extension == '.exe' || extension == '.app' || extension == '.deb') {
          return true; // Found an executable
        }
      }
    }

    return false; // No executables found
  }
}