// ============================================================================
// MOCK DATA HELPER (LIB VERSION)
// ============================================================================

/// Mock Data Generator
class MockData {
  // Valid admin credentials
  static const Map<String, String> validAdminCredentials = {
    'email': 'admin@jawara.com',
    'password': 'admin123',
  };

  // Invalid credentials
  static const Map<String, String> invalidCredentials = {
    'email': 'wrong@example.com',
    'password': 'wrongpassword',
  };

  // Valid email with wrong password
  static const Map<String, String> validEmailWrongPassword = {
    'email': 'admin@jawara.com',
    'password': 'wrongpassword123',
  };

  // Invalid email format
  static const Map<String, String> invalidEmailFormat = {
    'email': 'notanemail',
    'password': 'password123',
  };

  // Empty credentials
  static const Map<String, String> emptyCredentials = {
    'email': '',
    'password': '',
  };
}

