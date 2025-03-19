class ApiConstants {
  static const String baseUrl = 'https://servicescore-backend-1.onrender.com';

  // Auth endpoints
  static const String loginEndpoint = '/api/v1/users/login';
  static const String registerEndpoint = '/api/v1/users/register';
  static const String userProfileEndpoint = '/api/v1/users/info';

  // Event endpoints
  static const String eventsEndpoint = '/api/v1/events';
  static const String allEventsEndpoint = '/api/v1/events/all';
  static const String myEventsEndpoint = '/api/v1/events/all';
  static const String registerEventEndpoint = '/api/v1/registrations/';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';

  // New constants for Events
  static const String registrationsEndpoint = '/api/v1/registrations';
}
