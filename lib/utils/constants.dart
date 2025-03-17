class ApiConstants {
  static const String baseUrl = 'http://your-api-url.com';

  // Auth endpoints
  static const String loginEndpoint = '/api/v1/users/login';
  static const String registerEndpoint = '/api/v1/users/register';

  // Event endpoints
  static const String eventsEndpoint = '/api/v1/events';
  static const String myEventsEndpoint = '/api/v1/events/my-events';
  static const String registerEventEndpoint = '/api/v1/registrations/';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
}
