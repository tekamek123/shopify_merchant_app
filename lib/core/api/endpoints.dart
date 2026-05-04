class Endpoints {
  static const String baseUrl = "http://localhost:8000/api/v1"; // Update for production
  
  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refreshToken = "/auth/refresh";
  
  // Products
  static const String products = "/products";
  
  // Orders
  static const String orders = "/orders";
  
  // Analytics
  static const String dashboardStats = "/analytics/dashboard-stats";
}
