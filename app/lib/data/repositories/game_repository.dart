import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:gameverse/config/api_endpoints.dart';
import 'package:gameverse/domain/models/game_model/game_model.dart';

class GameRepository {
  final http.Client client;

  GameRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<GameModel>> getFeaturedGames() async {
    try {
      // In development, return mock data instead of API call
      // if (kDebugMode) {
      //   await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      //   return _getMockFeaturedGames();
      // }

      final response = await client.get(
        Uri.parse('${ApiEndpoint.storefrontUrl}/featured'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<GameModel> games = [];

        // Extract featured games
        if (data['featured_win'] != null) {
          for (var item in data['featured_win']) {
            games.add(GameModel(
              appId: item['id'] ?? 0,
              name: item['name'] ?? 'Unknown Game',
              recommended: item['recommended'] ?? 0,
              briefDescription: item['brief_description'] ?? '',
              description: item['description'] ?? item['brief_description'] ?? '',
              requirements: item['requirements'] ?? '',
              headerImage: item['large_capsule_image'] ?? '',
              screenshots: item['screenshots']?.cast<String>(),
              price: item['final_price'] != null ? 
                {'final': item['final_price'], 'discount_percent': item['discount_percent']} : null,
              categoriesID: item['categories']?.cast<String>() ?? [],
              isSale: item['discount_percent'] != null && item['discount_percent'] > 0,
              discountPercent: item['discount_percent']?.toDouble(),
              isOwned: false,
              installed: false,
              favorite: false,
            ));
          }
        }
        
        // Extract specials (discounted games)
        if (data['specials'] != null) {
          for (var item in data['specials']) {
            games.add(GameModel(
              appId: item['id'] ?? 0,
              name: item['name'] ?? 'Special Offer',
              recommended: item['recommended'] ?? 0,
              briefDescription: item['brief_description'] ?? '',
              description: item['description'] ?? item['brief_description'] ?? '',
              requirements: item['requirements'] ?? '',
              headerImage: item['large_capsule_image'] ?? '',
              screenshots: item['screenshots']?.cast<String>(),
              price: item['discounted'] ? 
                {'final': item['final_price'], 'original': item['original_price'], 
                 'discount_percent': item['discount_percent']} : null,
              categoriesID: item['categories']?.cast<String>() ?? [],
              isSale: item['discounted'] ?? false,
              discountPercent: item['discount_percent']?.toDouble(),
              isOwned: false,
              installed: false,
              favorite: false,
            ));
          }
        }
        
        return games;
      } else {
        throw Exception('Failed to load featured games: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching featured games, returning mock data: $e');
      return _getMockFeaturedGames();
    }
  }

  Future<List<GameModel>> getOwnedGames(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockOwnedGames();
  }

  Future<GameModel?> getGameDetails(int gameId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // First check in featured games
    final featuredGames = await getFeaturedGames();
    final featuredGame = featuredGames.firstWhere(
      (game) => game.appId == gameId,
      orElse: () => _createDetailedMockGame(gameId),
    );
    
    if (featuredGame.appId == gameId) {
      return featuredGame;
    }
    
    // Check in owned games
    final ownedGames = await getOwnedGames('user');
    try {
      return ownedGames.firstWhere((game) => game.appId == gameId);
    } catch (e) {
      // Return detailed mock game if not found
      return _createDetailedMockGame(gameId);
    }
  }

  Future<List<GameModel>> searchGames(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final allGames = [
      ..._getMockFeaturedGames(),
      ..._getMockOwnedGames(),
      ..._getMockAdditionalGames(),
    ];
    
    if (query.isEmpty) return allGames;
    
    return allGames.where((game) => 
      game.name.toLowerCase().contains(query.toLowerCase()) ||
      game.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Mock Data Methods
  List<GameModel> _getMockFeaturedGames() {
    return [
      GameModel(
        appId: 1091500,
        name: 'Cyberpunk 2077',
        recommended: 95,
        briefDescription: 'An open-world, action-adventure story set in Night City.',
        description: 'Cyberpunk 2077 is an open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification. You play as V, a mercenary outlaw going after a one-of-a-kind implant that is the key to immortality.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-3570K or AMD FX-8310, Memory: 8 GB RAM, Graphics: NVIDIA GeForce GTX 780 or AMD Radeon RX 470',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_814c156a6df96984349177d2e5df5b63a65b7321.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_67ba98b7f1dd3c54086b76f7d9dba97f7b19c3f3.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
        ],
        price: {'final': 2999, 'original': 5999, 'discount_percent': 50},
        categoriesID: ['RPG', 'Action', 'Open World'],
        isSale: true,
        discountPercent: 50.0,
        saleStartDate: DateTime.now().subtract(const Duration(days: 3)),
        saleEndDate: DateTime.now().add(const Duration(days: 4)),
        isOwned: false,
        installed: false,
        favorite: false,
      ),
      GameModel(
        appId: 1174180,
        name: 'Red Dead Redemption 2',
        recommended: 97,
        briefDescription: 'An epic tale of life in America\'s unforgiving heartland.',
        description: 'Arthur Morgan and the Van der Linde gang are outlaws on the run. With federal agents and the best bounty hunters in the nation massing on their heels, the gang must rob, steal and fight their way across the rugged heartland of America in order to survive.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-2500K / AMD FX-6300, Memory: 8 GB RAM, Graphics: Nvidia GeForce GTX 770 2GB / AMD Radeon R9 280',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_668dafe477743281eebce2b5b7e8b6a8ebedf9e4.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_2eb12dc29e1c83ba4f1b4df35d73d8b9da1c7e85.jpg',
        ],
        price: {'final': 3999, 'discount_percent': 0},
        categoriesID: ['Action', 'Adventure', 'Western'],
        isSale: false,
        isOwned: false,
        installed: false,
        favorite: false,
      ),
      GameModel(
        appId: 1222670,
        name: 'The Witcher 3: Wild Hunt',
        recommended: 98,
        briefDescription: 'The most awarded game of a generation is now enhanced for the next!',
        description: 'You are Geralt of Rivia, mercenary monster slayer. Before you stands a war-torn, monster-infested continent you can explore at will. Your current contract? Tracking down Ciri — the Child of Prophecy, a living weapon that can alter the shape of the world.',
        requirements: 'Minimum: OS: 64-bit Windows 10, Processor: Intel CPU Core i5-2500K 3.3GHz / AMD A10-5800K APU, Memory: 6 GB RAM, Graphics: Nvidia GPU GeForce GTX 660 / AMD GPU Radeon HD 7870',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_207e5c8689cea5eeee14d031e9e4a3ad3a80dda8.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_8b7f1e7d7d0b7e4f8e7d4a5c5e4f7e8d9f0a1b2c.jpg',
        ],
        price: {'final': 1999, 'original': 3999, 'discount_percent': 75},
        categoriesID: ['RPG', 'Open World', 'Fantasy'],
        isSale: true,
        discountPercent: 75.0,
        saleStartDate: DateTime.now().subtract(const Duration(days: 1)),
        saleEndDate: DateTime.now().add(const Duration(days: 6)),
        isOwned: false,
        installed: false,
        favorite: false,
      ),
      GameModel(
        appId: 271590,
        name: 'Grand Theft Auto V',
        recommended: 94,
        briefDescription: 'Grand Theft Auto V for PC offers players the option to explore the award-winning world of Los Santos and Blaine County.',
        description: 'When a young street hustler, a retired bank robber and a terrifying psychopath find themselves entangled with some of the most frightening and deranged elements of the criminal underworld, the U.S. government and the entertainment industry, they must pull off a series of dangerous heists to survive.',
        requirements: 'Minimum: OS: Windows 10 64 Bit, Processor: Intel Core 2 Quad CPU Q6600 @ 2.40GHz (4 CPUs) / AMD Phenom 9850 Quad-Core Processor (4 CPUs) @ 2.5GHz, Memory: 4 GB RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/271590/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/271590/ss_34c535d3a8f83a8ccaae7e15a0f7f810c1f32d2d.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/271590/ss_6c8ae5e0c55b5b0b4f6e7c8d9f0a1b2c3d4e5f6g.jpg',
        ],
        price: {'final': 1499, 'discount_percent': 0},
        categoriesID: ['Action', 'Adventure', 'Crime'],
        isSale: false,
        isOwned: false,
        installed: false,
        favorite: false,
      ),
    ];
  }

  List<GameModel> _getMockOwnedGames() {
    return [
      GameModel(
        appId: 570,
        name: 'Dota 2',
        recommended: 92,
        briefDescription: 'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes.',
        description: 'Every day, millions of players worldwide enter battle as one of over a hundred Dota heroes. And no matter if it\'s their 10th hour of play or 1,000th, there\'s always something new to discover. With regular updates that ensure a constant evolution of gameplay, features, and heroes, Dota 2 has taken on a life of its own.',
        requirements: 'Minimum: OS: Windows 10, Processor: Dual core from Intel or AMD at 2.8 GHz, Memory: 4 GB RAM, Graphics: nVidia GeForce 8600/9600GT, ATI/AMD Radeon HD2600/3600',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_d830cdf96919729c2b1d81876cb1ba8e7b1e7c25.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_bb5bf1d27ae13e8ef9fe9b9e4cdfba0e0aac2b1a.jpg',
        ],
        price: null, // Free to play
        categoriesID: ['MOBA', 'Strategy', 'Free to Play'],
        isSale: false,
        isOwned: true,
        installed: true,
        favorite: true,
        playtimeHours: 156.7,
      ),
      GameModel(
        appId: 730,
        name: 'Counter-Strike 2',
        recommended: 89,
        briefDescription: 'Counter-Strike 2 marks the beginning of a new chapter in the legendary FPS series.',
        description: 'For over two decades, Counter-Strike has offered an elite competitive experience, one shaped by millions of players from across the globe. And now the next chapter in the CS story is about to begin. This is Counter-Strike 2.',
        requirements: 'Minimum: OS: Windows 10, Processor: 4 hardware CPU threads - Intel® Core™ i5 750 or higher, Memory: 8 GB RAM, Graphics: Video card must be 1 GB or more',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/730/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_34309c49a2bb50e6b8a64454c632c5a289c8fd10.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_8db10c45158dd09fde9bfbcc8c866b31de1a14d5.jpg',
        ],
        price: null, // Free to play
        categoriesID: ['FPS', 'Competitive', 'Free to Play'],
        isSale: false,
        isOwned: true,
        installed: true,
        favorite: false,
        playtimeHours: 234.2,
      ),
      GameModel(
        appId: 440,
        name: 'Team Fortress 2',
        recommended: 88,
        briefDescription: 'Nine distinct classes provide a broad range of tactical abilities and personalities.',
        description: 'Nine distinct classes provide a broad range of tactical abilities and personalities. Constantly updated with new game modes, maps, equipment and, most importantly, hats!',
        requirements: 'Minimum: OS: Windows® 7 (32/64-bit)/Vista/XP, Processor: 1.7 GHz Processor or better, Memory: 512 MB RAM, Graphics: DirectX® 8.1 level Graphics Card',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/440/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_a1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_b2d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2.jpg',
        ],
        price: null, // Free to play
        categoriesID: ['FPS', 'Team-Based', 'Free to Play'],
        isSale: false,
        isOwned: true,
        installed: false,
        favorite: false,
        playtimeHours: 67.8,
      ),
      GameModel(
        appId: 72850,
        name: 'The Elder Scrolls V: Skyrim',
        recommended: 96,
        briefDescription: 'EPIC FANTASY REBORN - The next chapter in the highly anticipated Elder Scrolls saga.',
        description: 'EPIC FANTASY REBORN The next chapter in the highly anticipated Elder Scrolls saga arrives from the makers of the 2006 and 2008 Games of the Year, Bethesda Game Studios. Skyrim reimagines and revolutionizes the open-world fantasy epic.',
        requirements: 'Minimum: OS: Windows 7/Vista/XP PC (32 or 64 bit), Processor: Dual Core 2.0GHz or equivalent processor, Memory: 2GB System RAM, Graphics: Direct X 9.0c compliant video card with 512 MB of RAM',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/72850/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9.jpg',
          'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2f2e2d2f2.jpg',
        ],
        price: {'final': 1999, 'discount_percent': 0},
        categoriesID: ['RPG', 'Open World', 'Fantasy'],
        isSale: false,
        isOwned: true,
        installed: true,
        favorite: true,
        playtimeHours: 289.4,
      ),
    ];
  }

  List<GameModel> _getMockAdditionalGames() {
    return [
      GameModel(
        appId: 1086940,
        name: 'Baldur\'s Gate 3',
        recommended: 96,
        briefDescription: 'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal.',
        description: 'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal, sacrifice and survival, and the lure of absolute power. Mysterious abilities are awakening inside you, drawn from a mind flayer parasite planted in your brain.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel I5 4690 / AMD FX 8350, Memory: 8 GB RAM, Graphics: Nvidia GTX 970 / RX 480 (4GB+ of VRAM)',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1086940/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1086940/ss_e1f1e1f1e1f1e1f1e1f1e1f1e1f1e1f1e1f1e1f1.jpg',
        ],
        price: {'final': 5999, 'discount_percent': 0},
        categoriesID: ['RPG', 'Turn-Based Combat', 'Fantasy'],
        isSale: false,
        isOwned: false,
        installed: false,
        favorite: false,
      ),
      GameModel(
        appId: 1938090,
        name: 'Call of Duty®: Modern Warfare® III',
        recommended: 82,
        briefDescription: 'In the direct sequel to the record-breaking Call of Duty®: Modern Warfare® II.',
        description: 'In the direct sequel to the record-breaking Call of Duty®: Modern Warfare® II, Captain Price and Task Force 141 face off against the ultimate threat.',
        requirements: 'Minimum: OS: Windows® 10 64 Bit (latest update), Processor: AMD Ryzen™ 5 1400 or Intel® Core™ i5-6600K, Memory: 8 GB RAM, Graphics: AMD Radeon™ RX 470 or NVIDIA® GeForce® GTX 960',
        headerImage: 'https://cdn.akamai.steamstatic.com/steam/apps/1938090/header.jpg',
        screenshots: [
          'https://cdn.akamai.steamstatic.com/steam/apps/1938090/ss_f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2.jpg',
        ],
        price: {'final': 6999, 'discount_percent': 0},
        categoriesID: ['FPS', 'Action', 'Multiplayer'],
        isSale: false,
        isOwned: false,
        installed: false,
        favorite: false,
      ),
    ];
  }

  GameModel _createDetailedMockGame(int gameId) {
    return GameModel(
      appId: gameId,
      name: 'Game $gameId',
      recommended: 85,
      briefDescription: 'An exciting gaming experience that will keep you engaged for hours.',
      description: 'This is a comprehensive description of Game $gameId. It features stunning graphics, immersive gameplay, and an engaging storyline that will captivate players of all skill levels. The game includes multiple game modes, extensive customization options, and regular content updates.',
      requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-8400 / AMD Ryzen 5 2600, Memory: 8 GB RAM, Graphics: NVIDIA GeForce GTX 1060 / AMD Radeon RX 580, Storage: 50 GB available space',
      headerImage: 'https://via.placeholder.com/460x215/2196F3/FFFFFF?text=Game+$gameId',
      screenshots: [
        'https://via.placeholder.com/600x338/4CAF50/FFFFFF?text=Screenshot+1',
        'https://via.placeholder.com/600x338/FF9800/FFFFFF?text=Screenshot+2',
        'https://via.placeholder.com/600x338/9C27B0/FFFFFF?text=Screenshot+3',
      ],
      price: gameId % 3 == 0 ? null : {'final': 2999, 'discount_percent': gameId % 2 == 0 ? 25 : 0},
      categoriesID: ['Action', 'Adventure', 'Indie'],
      isSale: gameId % 2 == 0,
      discountPercent: gameId % 2 == 0 ? 25.0 : null,
      isOwned: false,
      installed: false,
      favorite: false,
    );
  }
}