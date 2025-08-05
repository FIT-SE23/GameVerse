// Define endpoint to communication between frontend and backend 

class ApiEndpoint {
  // Use your server URL instead of Steam API
  // static const String baseUrl = 'https://gameverse-99u7.onrender.com';
  // For local development, uncomment this:
  static const String baseUrl = 'http://localhost:1323';
  
  // Authentication endpoints
  static const String loginUrl = '$baseUrl/login';
  static const String registerUrl = '$baseUrl/register';
  static const String userUrl = '$baseUrl/user';
  
  // Game endpoints
  static const String gamesUrl = '$baseUrl/games';
  static const String libraryUrl = '$baseUrl/user';
  static const String wishlistUrl = '$baseUrl/user';
  
  // Other endpoints
  static const String searchUrl = '$baseUrl/search';
}