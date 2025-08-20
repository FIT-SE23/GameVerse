import 'package:flutter/foundation.dart';
import 'package:gameverse/data/repositories/operator_repository.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/domain/models/game_request_model/game_request_model.dart';
import 'package:gameverse/domain/models/publisher_request_model/publisher_request_model.dart';

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
    // Load initial data
    loadPendingRequests();  
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

      _pendingGameRequests = await OperatorRepository().getPendingGameRequests(
        _authRepository.accessToken,
      );
      
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
      
      _pendingPublisherRequests = await _operatorRepository.getPendingPublisherRequests(
        _authRepository.accessToken,
      );
      
      _state = OperatorViewState.success;
    } catch (e) {
      _state = OperatorViewState.error;
      _errorMessage = 'Failed to load publisher requests: $e';
    } finally {
      notifyListeners();
    }
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
      
      final success = await _operatorRepository.approveGameRequest(
        _authRepository.accessToken,
        requestId,
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
      
        // For production, call actual API
      final success = await _operatorRepository.rejectGameRequest(
        _authRepository.accessToken,
        _selectedGameRequest?.publisherId ?? '',
        requestId,
        feedback: feedback,
        gameName: _selectedGameRequest?.gameName ?? 'Unknown Game',
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
      
      final success = await _operatorRepository.approvePublisherRequest(
        _authRepository.accessToken,
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
      
      final success = await _operatorRepository.rejectPublisherRequest(
        _authRepository.accessToken,
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