import 'package:flutter/foundation.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

import 'package:gameverse/domain/models/game_model/game_model.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/category_model/category_model.dart';
import 'package:gameverse/domain/models/payment_method_model/payment_method_model.dart';
import 'package:gameverse/domain/models/user_model/user_model.dart';

enum PublisherViewState { loading, success, error }

class PublisherViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  final AuthRepository _authRepository;

  PublisherViewModel({required GameRepository gameRepository, required AuthRepository authRepository})
      : _gameRepository = gameRepository,
        _authRepository = authRepository;
  
  PublisherViewState _state = PublisherViewState.loading;
  PublisherViewState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<GameModel> _publishedGames = [];
  List<GameModel> get publishedGames => _publishedGames;

  List<GameRequestModel> _pendingRequests = [];
  List<GameRequestModel> get pendingRequests => _pendingRequests;

  UserModel? _publisherProfile;
  UserModel? get publisherProfile => _publisherProfile;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  // Register as publisher
  Future<bool> registerAsPublisher({
    required String userId,
    required String description,
    required String paymentMethodId,
  }) async {
    try {
      _state = PublisherViewState.loading;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create mock publisher profile
      _publisherProfile = UserModel(
        id: userId,
        username: 'Publisher_$userId',
        email: '123@gmail.com',
        type: 'publisher',
        description: description,
        paymentMethod: PaymentMethodModel(
          paymentMethodId: 'pm_${DateTime.now().millisecondsSinceEpoch}',
          type: 'Banking',
          information: 'Paypal',
        ),
        publishedGamesID: [],
      );

      _state = PublisherViewState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = PublisherViewState.error;
      _errorMessage = 'Registration failed: $e';
      notifyListeners();
      return false;
    }
  }

  // Load categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      _state = PublisherViewState.loading;
      notifyListeners();

      if (_gameRepository.categories.isNotEmpty) {
        _categories = _gameRepository.categories;
      } else {
        _categories = await _gameRepository.getCategories();
      }

      _state = PublisherViewState.success;
    } catch (e) {
      _state = PublisherViewState.error;
      _errorMessage = 'Failed to load categories: $e';
    } finally {
      notifyListeners();
    }
    return _categories;
  }

  // Load publisher data with mock data
  Future<void> loadPublisherData(String publisherId) async {
    try {
      _state = PublisherViewState.loading;
      notifyListeners();

      // Create mock publisher profile
      _publisherProfile = UserModel(
        id: publisherId,
        username: 'MockPublisher',
        email: '123@gmail.com',
        type: 'publisher',
        description: 'Indie game developer passionate about creating immersive gaming experiences',
        paymentMethod: PaymentMethodModel(
          paymentMethodId: 'pm_mock_001',
          type: 'Banking',
          information: 'PayPal',
        ),
        publishedGamesID: ['game_001', 'game_002'],
      );

      // Create mock published games
      _publishedGames = [
        GameModel(
          gameId: 'game_001',
          publisherId: publisherId,
          name: 'Mystery Adventure',
          recommended: 156,
          briefDescription: 'An exciting mystery adventure game',
          description: 'Embark on a thrilling mystery adventure where every choice matters. Solve puzzles, uncover secrets, and experience a story that adapts to your decisions.',
          requirement: 'Windows 10, 4GB RAM, DirectX 11',
          headerImage: 'https://picsum.photos/800/400?random=1',
          price: 19.99,
          categories: [
            CategoryModel(categoryId: '1', name: 'Adventure', isSensitive: false),
            CategoryModel(categoryId: '2', name: 'Mystery', isSensitive: false),
          ],
          media: [
            'https://picsum.photos/1920/1080?random=2',
            'https://picsum.photos/1920/1080?random=3',
          ],
          releaseDate: DateTime.now().subtract(const Duration(days: 30)),
          isSale: true,
          discountPercent: 20.0,
          saleStartDate: DateTime.now().subtract(const Duration(days: 5)),
          saleEndDate: DateTime.now().add(const Duration(days: 10)),
          isOwned: false,
          isInstalled: false,
          favorite: false,
        ),
        GameModel(
          gameId: 'game_002',
          publisherId: publisherId,
          name: 'Space Explorer',
          recommended: 89,
          briefDescription: 'Explore the vast universe',
          description: 'Build your spaceship, explore distant galaxies, and discover new civilizations in this epic space exploration game.',
          requirement: 'Windows 10, 6GB RAM, DirectX 12',
          headerImage: 'https://picsum.photos/800/400?random=4',
          price: 29.99,
          categories: [
            CategoryModel(categoryId: '3', name: 'Simulation', isSensitive: false),
            CategoryModel(categoryId: '4', name: 'Space', isSensitive: false),
          ],
          media: [
            'https://picsum.photos/1920/1080?random=5',
            'https://picsum.photos/1920/1080?random=6',
          ],
          releaseDate: DateTime.now().subtract(const Duration(days: 60)),
          isSale: false,
          isOwned: false,
          isInstalled: false,
          favorite: false,
        ),
      ];

      // Create mock pending requests
      _pendingRequests = [
        GameRequestModel(
          publisherId: publisherId,
          gameName: 'Pixel Warriors',
          description: 'A retro-style pixel art fighting game with local multiplayer support.',
          briefDescription: 'A retro-style pixel art fighting game with local multiplayer support.',
          requirements: 'Windows 7, 2GB RAM, OpenGL 2.0',
          headerImage: 'https://picsum.photos/800/400?random=7',
          media: [
            'https://picsum.photos/1920/1080?random=8',
            'https://picsum.photos/1920/1080?random=9',
          ],
          categories: [
            CategoryModel(categoryId: '5', name: 'Action', isSensitive: false),
            CategoryModel(categoryId: '6', name: 'Fighting', isSensitive: false),
          ],
          price: 14.99,
          status: 'pending',
          binaries: [
            'https://example.com/binaries/pixel_warriors_v1.0.bin',
          ],
          exes: [
            'https://example.com/exes/pixel_warriors_v1.0.exe',
          ],
          submissionDate: DateTime.now().subtract(const Duration(days: 10)),
        ),
        GameRequestModel(
          gameName: 'Farm Simulator Pro',
          publisherId: publisherId,
          briefDescription: 'The ultimate farming experience with realistic farming mechanics.',
          description: 'The ultimate farming experience with realistic farming mechanics.',
          requirements: 'Windows 10, 8GB RAM, DirectX 11',
          headerImage: 'https://picsum.photos/800/400?random=10',
          media: [
            'https://picsum.photos/1920/1080?random=11',
            'https://picsum.photos/1920/1080?random=12',
          ],
          categories: [
            CategoryModel(categoryId: '7', name: 'Simulation', isSensitive: false),
            CategoryModel(categoryId: '8', name: 'Farming', isSensitive: false),
          ],
          price: 24.99,
          status: 'pending',
          binaries: [
            'https://example.com/binaries/farm_simulator_pro_v1.0.bin',
          ],
          exes: [
            'https://example.com/exes/farm_simulator_pro_v1.0.exe',
          ],
          submissionDate: DateTime.now().subtract(const Duration(days: 5),
        ),
      )];

      _state = PublisherViewState.success;
    } catch (e) {
      _state = PublisherViewState.error;
      _errorMessage = 'Failed to load publisher data: $e';
    } finally {
      notifyListeners();
    }
  }

  // Request game publication
  Future<bool> requestGamePublication({
    required String publisherId,
    required String gameName,
    required String description,
    required List<CategoryModel> categories,
    required double price,
    required String briefDescription,
    required String requirements,
    required String headerImage,
    required List<String> media,
    required String requestMessage,
    required List<String> binaries,
    required List<String> exes,
  }) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final newRequest = GameRequestModel(
        gameName: gameName,
        publisherId: publisherId,
        description: description,
        briefDescription: briefDescription,
        requirements: requirements,
        headerImage: headerImage,
        media: media,
        categories: categories,
        price: price,
        status: 'pending',
        binaries: binaries,
        exes: exes,
        submissionDate: DateTime.now(),
      );

      // debugPrint('Requesting game publication: $newRequest');
      bool isSuccess = await _gameRepository.
                              requestGamePublication(_authRepository.accessToken!, newRequest);
      if (!isSuccess) {
        _errorMessage = 'Failed to request game publication';
        notifyListeners();
        return false;
      }

      _pendingRequests.insert(0, newRequest);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Request failed: $e';
      return false;
    }
  }

  // Cancel game request
  Future<bool> cancelGameRequest(String gameName) async {
    try {
      _pendingRequests.removeWhere((request) => request.gameName == gameName);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Cancellation failed: $e';
      return false;
    }
  }
}