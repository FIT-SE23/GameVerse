// Define endpoint to communication between frontend and backend 

class ApiEndpoints {
  // Use your server URL instead of Steam API
  // For local development vs production
  static const bool debug = bool.fromEnvironment('DEBUG', defaultValue: false);
  static const String baseUrl = debug 
      ? 'http://localhost:1323'         // Local development URL
      : 'https://gameverse-99u7.onrender.com'; // Production URL
  
  // Authentication endpoints
  static const String loginUrl = '$baseUrl/login';
  static const String registerUrl = '$baseUrl/register';
  static const String userUrl = '$baseUrl/user';
  
  // Game endpoints
  static const String gameUrl = '$baseUrl/game';
  static const String addGameToUrl = '$baseUrl/addgameto';
  static const String removeGameFromUrl = '$baseUrl/removegamefrom';
  static const String recommendedGamesUrl = '$baseUrl/recommended';

  // Transaction endpoints
  static const String transactionUrl = '$baseUrl/transaction';

  // Operator endpoints
  static const String operatorGameRequests = '$baseUrl/operator/game-requests';
  static const String operatorPublisherRequests = '$baseUrl/operator/publisher-requests';
  
  // Other endpoints
  static const String searchUrl = '$baseUrl/search';
}