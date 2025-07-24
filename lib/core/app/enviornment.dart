class Environment {
  static const String baseUrl = 'https://parseapi.back4app.com/functions';

  // Parse server keys — replace with your actual values
  static const String appId = 'wK7GcEjr2V4br5q5mlR1kybQ5dvxMFDX0qtE1d6Y';
  static const String restApiKey = '2kahi62fkWePLWAwC7k8aMrtQkobogcgkruMxbeB';

  static const Map<String, String> defaultHeaders = {
    'X-Parse-Application-Id': appId,
    'X-Parse-REST-API-Key': restApiKey,
    'Content-Type': 'application/json',
  };

  static const String signIn = '$baseUrl/login';
  static const String signUp = '$baseUrl/signup';
  static const String validateToken = '$baseUrl/validate-token';
  static const String refreshToken = '$baseUrl/refresh-token';

  // home screen
  static const String getAllCategory = '$baseUrl/get-category-list';
  static const String getAllProducts = '$baseUrl/get-product-list';

  // cart screen
  static const String getAllItemsFromCart = '$baseUrl/get-cart-items';
  static const String addItemsToCart = '$baseUrl/add-item-to-cart';
}
