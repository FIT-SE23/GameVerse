import 'package:flutter/foundation.dart';
import 'package:gameverse/data/repositories/operator_repository.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/publisher_request_model/publisher_request_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';

enum OperatorViewState { initial, loading, success, error }
enum OperatorTab { games, publishers }

class OperatorViewModel extends ChangeNotifier {
  final OperatorRepository _operatorRepository;
  final AuthRepository _authRepository;
  
  OperatorViewModel({
    required OperatorRepository operatorRepository,
    required AuthRepository authRepository,
  })  : _operatorRepository = operatorRepository,
        _authRepository = authRepository {
    // Initialize with mock data in development mode
    if (kDebugMode) {
      _pendingGameRequests = _generateMockGameRequests();
      _pendingPublisherRequests = _generateMockPublisherRequests();
      _state = OperatorViewState.success;
    }
  }
  
  OperatorViewState _state = OperatorViewState.initial;
  String _errorMessage = '';
  
  // Active tab
  OperatorTab _activeTab = OperatorTab.games;
  
  // Game requests
  List<GameRequestModel> _pendingGameRequests = [];
  GameRequestModel? _selectedGameRequest;
  
  // Publisher requests
  List<PublisherRequestModel> _pendingPublisherRequests = [];
  PublisherRequestModel? _selectedPublisherRequest;
  
  // Getters
  OperatorViewState get state => _state;
  String get errorMessage => _errorMessage;
  OperatorTab get activeTab => _activeTab;
  
  // Game requests getters
  List<GameRequestModel> get pendingGameRequests => _pendingGameRequests;
  GameRequestModel? get selectedGameRequest => _selectedGameRequest;
  bool get hasSelectedGameRequest => _selectedGameRequest != null;
  
  // Publisher requests getters
  List<PublisherRequestModel> get pendingPublisherRequests => _pendingPublisherRequests;
  PublisherRequestModel? get selectedPublisherRequest => _selectedPublisherRequest;
  bool get hasSelectedPublisherRequest => _selectedPublisherRequest != null;
  
  // Set active tab
  void setActiveTab(OperatorTab tab) {
    _activeTab = tab;
    // Clear selections when switching tabs
    if (tab == OperatorTab.games) {
      _selectedPublisherRequest = null;
    } else {
      _selectedGameRequest = null;
    }
    notifyListeners();
  }
  
  // Load all pending requests based on active tab
  Future<void> loadPendingRequests() async {
    if (_activeTab == OperatorTab.games) {
      await loadPendingGameRequests();
    } else {
      await loadPendingPublisherRequests();
    }
  }
  
  // Load all pending game requests
  Future<void> loadPendingGameRequests() async {
    try {
      _state = OperatorViewState.loading;
      notifyListeners();
      
      // For development/testing, use mock data
      // if (kDebugMode) {
        await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
        _pendingGameRequests = _generateMockGameRequests();
      // } else {
      //   // For production, use actual API
      //   final requests = await _operatorRepository.getPendingGameRequests(
      //     _authRepository.accessToken!,
      //   );
      //   _pendingGameRequests = requests;
      // }
      
      _state = OperatorViewState.success;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to load game requests: $e';
    } finally {
      notifyListeners();
    }
  }
  
  // Load all pending publisher requests
  Future<void> loadPendingPublisherRequests() async {
    try {
      _state = OperatorViewState.loading;
      notifyListeners();
      
      // For development/testing, use mock data
      // if (kDebugMode) {
        await Future.delayed(const Duration(milliseconds: 200)); // Simulate network delay
        _pendingPublisherRequests = _generateMockPublisherRequests();
      // } else {
      //   // For production, use actual API
      //   final requests = await _operatorRepository.getPendingPublisherRequests(
      //     _authRepository.accessToken!,
      //   );
      //   _pendingPublisherRequests = requests;
      // }
      
      _state = OperatorViewState.success;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to load publisher requests: $e';
    } finally {
      notifyListeners();
    }
  }
  
  // Generate mock data for game requests
// Generate mock data for testing
  List<GameRequestModel> _generateMockGameRequests() {
    return [
      GameRequestModel(
        requestId: "req1",
        publisherId: "pub1",
        gameName: "Epic Adventure Quest",
        briefDescription: "An exciting adventure game with epic quests",
        description: "An exciting adventure game where players explore vast landscapes and battle fierce enemies. Features include multiplayer modes, character customization, and dynamic quests. Experience a rich storytelling environment with hundreds of hours of gameplay.",
        requirements: "OS: Windows 10 64-bit\nCPU: Intel Core i5-4460 or AMD FX-8350\nMemory: 8 GB RAM\nGraphics: NVIDIA GeForce GTX 970 or AMD Radeon R9 290\nDirectX: Version 11\nStorage: 50 GB available space",
        headerImage: "https://picsum.photos/id/237/800/450",
        price: 29.99,
        categories: [
          CategoryModel(categoryId: "1", name: "Action", isSensitive: false),
          CategoryModel(categoryId: "2", name: "Adventure", isSensitive: false),
        ],
        media: [
          "https://picsum.photos/id/238/800/450",
          "https://picsum.photos/id/239/800/450",
          "https://picsum.photos/id/240/800/450",
        ],
        status: "pending",
        binaries: ["game_data.bin", "resources.pak"],
        exes: ["epic_adventure.exe", "launcher.exe"],
        submissionDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      GameRequestModel(
        requestId: "req2",
        publisherId: "pub2",
        gameName: "Space Odyssey",
        briefDescription: "An immersive space exploration RPG",
        description: "An immersive role-playing game set in a futuristic space environment. Players can explore galaxies, upgrade their ships, and engage in strategic combat. Discover alien civilizations and make choices that impact the universe.",
        requirements: "OS: Windows 10 64-bit\nCPU: Intel Core i7-8700K or AMD Ryzen 5 3600X\nMemory: 16 GB RAM\nGraphics: NVIDIA GeForce RTX 2060 or AMD Radeon RX 5700\nDirectX: Version 12\nStorage: 100 GB available space",
        headerImage: "https://picsum.photos/id/20/800/450",
        price: 39.99,
        categories: [
          CategoryModel(categoryId: "3", name: "RPG", isSensitive: false),
          CategoryModel(categoryId: "4", name: "Strategy", isSensitive: false),
          CategoryModel(categoryId: "9", name: "Sci-Fi", isSensitive: false),
        ],
        media: [
          "https://picsum.photos/id/21/800/450",
          "https://picsum.photos/id/22/800/450",
        ],
        status: "pending",
        binaries: ["space_odyssey.bin", "space_resources.pak"],
        exes: ["space_odyssey.exe"],
        submissionDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      GameRequestModel(
        requestId: "req3",
        publisherId: "pub3",
        gameName: "Pixel Warrior",
        briefDescription: "A retro-style platformer with modern gameplay",
        description: "A retro-style platformer with modern gameplay mechanics. Navigate through dangerous levels, collect power-ups, and defeat the evil pixel monsters. Features pixel-perfect controls and a dynamic difficulty system.",
        requirements: "OS: Windows 7/8/10\nCPU: Intel Core i3-3220 or AMD Athlon II X2 270\nMemory: 4 GB RAM\nGraphics: NVIDIA GeForce GTX 560 or AMD Radeon HD 7770\nDirectX: Version 10\nStorage: 2 GB available space",
        headerImage: "https://picsum.photos/id/96/800/450",
        price: 19.99,
        categories: [
          CategoryModel(categoryId: "10", name: "Platformer", isSensitive: false),
          CategoryModel(categoryId: "11", name: "Indie", isSensitive: false),
          CategoryModel(categoryId: "12", name: "Retro", isSensitive: false),
          CategoryModel(categoryId: "1", name: "Action", isSensitive: false),
        ],
        media: [
          "https://picsum.photos/id/97/800/450",
          "https://picsum.photos/id/98/800/450",
          "https://picsum.photos/id/99/800/450",
          "https://picsum.photos/id/100/800/450",
        ],
        status: "pending",
        binaries: ["pixel_data.bin"],
        exes: ["pixel_warrior.exe"],
        submissionDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      GameRequestModel(
        requestId: "req4",
        publisherId: "pub2",
        gameName: "Strategic Conquest",
        briefDescription: "A complex strategy game with empire building",
        description: "A complex strategy game where players build empires, manage resources, and engage in tactical warfare. Features diplomacy systems and economic management. Plan your conquest carefully and outsmart your opponents.",
        requirements: "OS: Windows 8/10\nCPU: Intel Core i5-6600K or AMD Ryzen 3 3300X\nMemory: 8 GB RAM\nGraphics: NVIDIA GeForce GTX 1060 or AMD Radeon RX 580\nDirectX: Version 11\nStorage: 30 GB available space",
        headerImage: "https://picsum.photos/id/64/800/450",
        price: 49.99,
        categories: [
          CategoryModel(categoryId: "4", name: "Strategy", isSensitive: false),
          CategoryModel(categoryId: "13", name: "4X", isSensitive: false),
          CategoryModel(categoryId: "14", name: "Turn-Based", isSensitive: false),
        ],
        media: [
          "https://picsum.photos/id/65/800/450",
          "https://picsum.photos/id/66/800/450",
        ],
        status: "pending",
        binaries: ["strategic_conquest.bin", "conquest_data.pak"],
        exes: ["strategic_conquest.exe", "editor.exe"],
        submissionDate: DateTime.now().subtract(const Duration(days: 4)),
      ),
      GameRequestModel(
        requestId: "req5",
        publisherId: "pub4",
        gameName: "Racing Extreme",
        briefDescription: "High-speed racing with realistic physics",
        description: "Experience high-speed racing across various terrains and weather conditions. Featuring realistic physics, car customization, and competitive multiplayer modes. Race against the best drivers in the world and become a champion.",
        requirements: "OS: Windows 10 64-bit\nCPU: Intel Core i5-8600K or AMD Ryzen 5 2600X\nMemory: 16 GB RAM\nGraphics: NVIDIA GeForce GTX 1660 Ti or AMD Radeon RX 5600 XT\nDirectX: Version 12\nStorage: 60 GB available space",
        headerImage: "https://picsum.photos/id/133/800/450",
        price: 34.99,
        categories: [
          CategoryModel(categoryId: "7", name: "Racing", isSensitive: false),
          CategoryModel(categoryId: "8", name: "Sports", isSensitive: false),
          CategoryModel(categoryId: "15", name: "Simulation", isSensitive: false),
        ],
        media: [
          "https://picsum.photos/id/134/800/450",
          "https://picsum.photos/id/135/800/450",
          "https://picsum.photos/id/136/800/450",
        ],
        status: "pending",
        binaries: ["racing_data.bin", "car_models.pak"],
        exes: ["racing_extreme.exe", "car_config.exe"],
        submissionDate: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];
  }

  // Generate mock data for publisher requests
  List<PublisherRequestModel> _generateMockPublisherRequests() {
    return [
      PublisherRequestModel(
        requestId: "pub_req1",
        userId: "user1",
        username: "GameStudio123",
        email: "contact@gamestudio123.com",
        description: "We are an indie game studio focused on creating innovative puzzle games. With over 5 years of experience in the industry, our team of 10 developers has published several successful titles on mobile platforms. We're excited to bring our unique gaming experiences to GameVerse.",
        paymentMethod: const PaymentMethodModel(
          paymentMethodId: "pm1",
          type: "PayPal",
          information: "payments@gamestudio123.com",
        ),
        status: "pending",
        submissionDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PublisherRequestModel(
        requestId: "pub_req2",
        userId: "user2",
        username: "RPGMasters",
        email: "info@rpgmasters.net",
        description: "RPGMasters is a veteran game development team specializing in role-playing games with deep storytelling and strategic gameplay. Founded in 2018, we've developed 3 successful PC titles with positive reviews. Our mission is to create immersive fantasy worlds that captivate players.",
        paymentMethod: const PaymentMethodModel(
          paymentMethodId: "pm2",
          type: "VNPay",
          information: "9876543210",
        ),
        status: "pending",
        submissionDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      PublisherRequestModel(
        requestId: "pub_req3",
        userId: "user3",
        username: "SoloDevStudio",
        email: "john.dev@example.com",
        description: "I'm John, an independent game developer with a passion for creating unique 2D platformers. I've been developing games for 3 years, with two successful releases on other platforms. I focus on pixel art aesthetics and challenging gameplay mechanics.",
        paymentMethod: const PaymentMethodModel(
          paymentMethodId: "pm3",
          type: "PayPal",
          information: "john.payments@example.com",
        ),
        status: "pending",
        submissionDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
  
  // Game request selection and actions
  void selectGameRequest(GameRequestModel request) {
    _selectedGameRequest = request;
    notifyListeners();
  }
  
  void clearSelectedGameRequest() {
    _selectedGameRequest = null;
    notifyListeners();
  }
  
  // Publisher request selection and actions
  void selectPublisherRequest(PublisherRequestModel request) {
    _selectedPublisherRequest = request;
    notifyListeners();
  }
  
  void clearSelectedPublisherRequest() {
    _selectedPublisherRequest = null;
    notifyListeners();
  }
  
  // Approve a game request
  Future<bool> approveGameRequest(String? requestId, {String? feedback}) async {
    if (requestId == null) return false;
    
    try {
      _state = OperatorViewState.loading;
      notifyListeners();
      
      // For development/testing, simulate API call
      // if (kDebugMode) {
      //   await Future.delayed(const Duration(seconds: 1));
      //   // Update local data for testing
      //   _pendingGameRequests.removeWhere((req) => req.requestId == requestId);
      //   if (_selectedGameRequest?.requestId == requestId) {
      //     _selectedGameRequest = null;
      //   }
      // } else {
        // For production, call actual API
        final success = await _operatorRepository.approveGameRequest(
          _authRepository.accessToken!,
          requestId,
          feedback: feedback,
        );
        
        if (success) {
          _pendingGameRequests.removeWhere((req) => req.requestId == requestId);
          if (_selectedGameRequest?.requestId == requestId) {
            _selectedGameRequest = null;
          }
        } else {
          _state = OperatorViewState.error;
          _errorMessage = 'Failed to approve request';
          notifyListeners();
          return false;
        }
      // }
      
      _state = OperatorViewState.success;
      notifyListeners();
      
      return true;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to approve request: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Reject a game request
  Future<bool> rejectGameRequest(String? requestId, {required String feedback}) async {
    if (requestId == null) return false;
    
    try {
      _state = OperatorViewState.loading;
      notifyListeners();
      
      // For development/testing, simulate API call
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 1));
        // Update local data for testing
        _pendingGameRequests.removeWhere((req) => req.requestId == requestId);
        if (_selectedGameRequest?.requestId == requestId) {
          _selectedGameRequest = null;
        }
      } else {
        // For production, call actual API
        final success = await _operatorRepository.rejectGameRequest(
          _authRepository.accessToken!,
          requestId,
          feedback: feedback,
        );
        
        if (success) {
          _pendingGameRequests.removeWhere((req) => req.requestId == requestId);
          if (_selectedGameRequest?.requestId == requestId) {
            _selectedGameRequest = null;
          }
        } else {
          _state = OperatorViewState.error;
          _errorMessage = 'Failed to reject request';
          notifyListeners();
          return false;
        }
      }
      
      _state = OperatorViewState.success;
      notifyListeners();
      
      return true;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to reject request: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Approve a publisher request
  Future<bool> approvePublisherRequest(String? requestId, {String? feedback}) async {
    if (requestId == null) return false;
    
    try {
      _state = OperatorViewState.loading;
      notifyListeners();
      
      // For development/testing, simulate API call
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 1));
        // Update local data for testing
        _pendingPublisherRequests.removeWhere((req) => req.requestId == requestId);
        if (_selectedPublisherRequest?.requestId == requestId) {
          _selectedPublisherRequest = null;
        }
      } else {
        // For production, call actual API
        final success = await _operatorRepository.approvePublisherRequest(
          _authRepository.accessToken!,
          requestId,
          feedback: feedback,
        );
        
        if (success) {
          _pendingPublisherRequests.removeWhere((req) => req.requestId == requestId);
          if (_selectedPublisherRequest?.requestId == requestId) {
            _selectedPublisherRequest = null;
          }
        } else {
          _state = OperatorViewState.error;
          _errorMessage = 'Failed to approve publisher request';
          notifyListeners();
          return false;
        }
      }
      
      _state = OperatorViewState.success;
      notifyListeners();
      
      return true;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to approve publisher request: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Reject a publisher request
  Future<bool> rejectPublisherRequest(String? requestId, {required String feedback}) async {
    if (requestId == null) return false;
    
    try {
      _state = OperatorViewState.loading;
      notifyListeners();
      
      // For development/testing, simulate API call
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 1));
        // Update local data for testing
        _pendingPublisherRequests.removeWhere((req) => req.requestId == requestId);
        if (_selectedPublisherRequest?.requestId == requestId) {
          _selectedPublisherRequest = null;
        }
      } else {
        // For production, call actual API
        final success = await _operatorRepository.rejectPublisherRequest(
          _authRepository.accessToken!,
          requestId,
          feedback: feedback,
        );
        
        if (success) {
          _pendingPublisherRequests.removeWhere((req) => req.requestId == requestId);
          if (_selectedPublisherRequest?.requestId == requestId) {
            _selectedPublisherRequest = null;
          }
        } else {
          _state = OperatorViewState.error;
          _errorMessage = 'Failed to reject publisher request';
          notifyListeners();
          return false;
        }
      }
      
      _state = OperatorViewState.success;
      notifyListeners();
      
      return true;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to reject publisher request: $e';
      notifyListeners();
      return false;
    }
  }
}