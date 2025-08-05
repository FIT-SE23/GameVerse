import 'package:http/http.dart' as http;

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/resource_model/resource_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';

class GameRepository {
  final http.Client client;

  GameRepository({http.Client? httpClient}) : client = httpClient ?? http.Client();

  Future<List<GameModel>> getFeaturedGames() async {
    return _getMockFeaturedGames();
  }

  Future<List<GameModel>> getOwnedGames(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockOwnedGames();
  }

  Future<GameModel?> getGameDetails(String gameId) async {
    await Future.delayed(const Duration(milliseconds: 300));


    
    // First check in featured games
    final featuredGames = await getFeaturedGames();
    final featuredGame = featuredGames.firstWhere(
      (game) => game.gameId == gameId,
    );
    
    if (featuredGame.gameId == gameId) {
      return featuredGame;
    }
    
    // Check in owned games
    final ownedGames = await getOwnedGames('user');
    try {
      return ownedGames.firstWhere((game) => game.gameId == gameId);
    } catch (e) {
      // If not found in owned games, return null
      return null;
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
        gameId: '1',
        publisherId: '1',
        name: 'Cyberpunk 2077',
        recommended: 95,
        briefDescription: 'An open-world, action-adventure story set in Night City.',
        description: 'Cyberpunk 2077 is an open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification. You play as V, a mercenary outlaw going after a one-of-a-kind implant that is the key to immortality.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel Core i5-3570K or AMD FX-8310, Memory: 8 GB RAM, Graphics: NVIDIA GeForce GTX 780 or AMD Radeon RX 470',
        headerImage: ResourceModel(
          resourceId: '1',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '1',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_814c156a6df96984349177d2e5df5b63a65b7321.jpg',
          ),
          ResourceModel(
            resourceId: '2',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_67ba98b7f1dd3c54086b76f7d9dba97f7b19c3f3.jpg',
          ),
          ResourceModel(
            resourceId: '3',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
          ),
        ],
        price: 29.99,
        categories: [
          CategoryModel(categoryId: '1', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '2', name: 'Action', isSensitive: false),
        ],
        releaseDate: DateTime(2020, 12, 10),
        isSale: true,
        discountPercent: 50.0,
        saleStartDate: DateTime.now().subtract(const Duration(days: 3)),
        saleEndDate: DateTime.now().add(const Duration(days: 4)),
        isOwned: false,
        installed: false,
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
        headerImage: ResourceModel(
          resourceId: '4',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '4',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_668dafe477743281eebce2b5b7e8b6a8ebedf9e4.jpg',
          ),
          ResourceModel(
            resourceId: '5',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1174180/ss_2eb12dc29e1c83ba4f1b4df35d73d8b9da1c7e85.jpg',
          ),
        ],
        price: 49.99,
        categories: [
          CategoryModel(categoryId: '3', name: 'Adventure', isSensitive: false),
          CategoryModel(categoryId: '4', name: 'Open World', isSensitive: false),
        ],
        releaseDate: DateTime(2019, 11, 5),
        isSale: false,
        isOwned: false,
        installed: false,
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
        headerImage: ResourceModel(
          resourceId: '6',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '6',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_207e5c8689cea5eeee14d031e9e4a3ad3a80dda8.jpg',
          ),
          ResourceModel(
            resourceId: '7',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/ss_8b7f1e7d7d0b7e4f8e7d4a5c5e4f7e8d9f0a1b2c.jpg',
          ),
        ],
        price: 39.99,
        categories: [
          CategoryModel(categoryId: '5', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '6', name: 'Fantasy', isSensitive: false),
        ],
        releaseDate: DateTime(2015, 5, 19),
        isSale: true,
        discountPercent: 75.0,
        saleStartDate: DateTime.now().subtract(const Duration(days: 1)),
        saleEndDate: DateTime.now().add(const Duration(days: 6)),
        isOwned: false,
        installed: false,
        favorite: false,
      )
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
        headerImage: ResourceModel(
          resourceId: '8',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/570/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '9',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_d830cdf96919729c2b1d81876cb1ba8e7b1e7c25.jpg',
          ),
          ResourceModel(
            resourceId: '10',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/570/ss_bb5bf1d27ae13e8ef9fe9b9e4cdfba0e0aac2b1a.jpg',
          ),
        ],
        price: 0.0, // Free to play
        categories: [
          CategoryModel(categoryId: '7', name: 'MOBA', isSensitive: false),
          CategoryModel(categoryId: '8', name: 'Strategy', isSensitive: false),
        ],
        releaseDate: DateTime(2013, 7, 9),
        isSale: false,
        isOwned: true,
        installed: true,
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
        headerImage: ResourceModel(
          resourceId: '11',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/730/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '12',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_34309c49a2bb50e6b8a64454c632c5a289c8fd10.jpg',
          ),
          ResourceModel(
            resourceId: '13',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/730/ss_8db10c45158dd09fde9bfbcc8c866b31de1a14d5.jpg',
          ),
        ],
        price: 0.0, // Free to play
        categories: [
          CategoryModel(categoryId: '9', name: 'FPS', isSensitive: false),
          CategoryModel(categoryId: '10', name: 'Competitive', isSensitive: false),
        ],
        releaseDate: DateTime(2023, 9, 27),
        isSale: false,
        isOwned: true,
        installed: true,
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
        headerImage: ResourceModel(
          resourceId: '14',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/440/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '15',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_a1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1e9e1c1.jpg',
          ),
          ResourceModel(
            resourceId: '16',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/440/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
          ),
        ],
        price: 0.0, // Free to play
        categories: [
          CategoryModel(categoryId: '11', name: 'FPS', isSensitive: false),
          CategoryModel(categoryId: '12', name: 'Multiplayer', isSensitive: false),
        ],
        releaseDate: DateTime(2007, 10, 10),
        isSale: false,
        isOwned: true,
        installed: false,
        favorite: false,
        playtimeHours: 67.8,
      ),
      GameModel(
        gameId: '8',
        publisherId: '5',
        name: 'The Elder Scrolls V: Skyrim',
        recommended: 96,
        briefDescription: 'EPIC FANTASY REBORN - The next chapter in the highly anticipated Elder Scrolls saga.',
        description: 'EPIC FANTASY REBORN The next chapter in the highly anticipated Elder Scrolls saga arrives from the makers of the 2006 and 2008 Games of the Year, Bethesda Game Studios. Skyrim reimagines and revolutionizes the open-world fantasy epic.',
        requirements: 'Minimum: OS: Windows 7/Vista/XP PC (32 or 64 bit), Processor: Dual Core 2.0GHz or equivalent processor, Memory: 2GB System RAM, Graphics: Direct X 9.0c compliant video card with 512 MB of RAM',
        headerImage: ResourceModel(
          resourceId: '17',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/72850/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '18',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
          ),
          ResourceModel(
            resourceId: '19',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/72850/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
          ),
        ],
        price: 19.99,
        categories: [
          CategoryModel(categoryId: '13', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '14', name: 'Fantasy', isSensitive: false),
        ],
        releaseDate: DateTime(2011, 11, 11),
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
        gameId: '9',
        publisherId: '6',
        name: 'Baldur\'s Gate 3',
        recommended: 96,
        briefDescription: 'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal.',
        description: 'Gather your party and return to the Forgotten Realms in a tale of fellowship and betrayal, sacrifice and survival, and the lure of absolute power. Mysterious abilities are awakening inside you, drawn from a mind flayer parasite planted in your brain.',
        requirements: 'Minimum: OS: Windows 10 64-bit, Processor: Intel I5 4690 / AMD FX 8350, Memory: 8 GB RAM, Graphics: Nvidia GTX 970 / RX 480 (4GB+ of VRAM)',
        headerImage: ResourceModel(
          resourceId: '20',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/1086940/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '21',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1086940/ss_8e5d17cc8cfcbc3e6dc1b7c93f3b6d6c0e1e46cd.jpg',
          ),
        ],
        price: 59.99,
        categories: [
          CategoryModel(categoryId: '15', name: 'RPG', isSensitive: false),
          CategoryModel(categoryId: '16', name: 'Adventure', isSensitive: false),
        ],
        releaseDate: DateTime(2023, 8, 3),
        isSale: false,
        isOwned: false,
        installed: false,
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
        headerImage: ResourceModel(
          resourceId: '22',
          type: 'image',
          url: 'https://cdn.akamai.steamstatic.com/steam/apps/1938090/header.jpg',
        ),
        resources: [
          ResourceModel(
            resourceId: '23',
            type: 'image',
            url: 'https://cdn.akamai.steamstatic.com/steam/apps/1938090/ss_f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2f2g2.jpg',
          ),
        ],
        price: 59.99,
        categories: [
          CategoryModel(categoryId: '17', name: 'FPS', isSensitive: false),
          CategoryModel(categoryId: '18', name: 'Action', isSensitive: false),
        ],
        releaseDate: DateTime(2023, 11, 10),
        isSale: false,
        isOwned: false,
        installed: false,
        favorite: false,
      ),
    ];
  }
}