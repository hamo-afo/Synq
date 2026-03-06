/// API Configuration Keys
///
/// Instructions for obtaining API keys:
///
/// 1. YouTube Data API v3:
///    - Go to: https://console.cloud.google.com
///    - Create a new project
///    - Enable "YouTube Data API v3"
///    - Create an API key in credentials
///    - Paste your key below
///
/// 2. Alpha Vantage (Stock API):
///    - Go to: https://www.alphavantage.co/api/
///    - Sign up for free API key
///    - Paste your key below
///
/// 3. NewsAPI (Political News):
///    - Go to: https://newsapi.org
///    - Sign up for free API key
///    - Paste your key below

class ApiKeys {
  /// YouTube Data API v3 Key
  /// Get from: https://console.cloud.google.com
  static const String youtubeApiKey = 'AIzaSyD1Msa_UZMLH7w_dpMSC4Fgv9Vu8TzomXA';

  /// Alpha Vantage API Key for stock data
  /// Get from: https://www.alphavantage.co/api/
  static const String alphaVantageApiKey = 'JJ6K4R4PDLAZXEKP';

  /// NewsAPI Key for political news
  /// Get from: https://newsapi.org
  static const String newsApiKey = '65d9248818f24c2eb8c78dcbaa0d8eb8';

  /// Validate that all API keys are set
  static bool validateKeys() {
    final keys = [youtubeApiKey, alphaVantageApiKey, newsApiKey];
    return keys.every((key) => key.isNotEmpty && !key.contains('YOUR_'));
  }

  /// Get validation error message
  static String getValidationError() {
    final missing = <String>[];

    if (youtubeApiKey.isEmpty || youtubeApiKey.contains('YOUR_')) {
      missing.add('YouTube API Key');
    }
    if (alphaVantageApiKey.isEmpty || alphaVantageApiKey.contains('YOUR_')) {
      missing.add('Alpha Vantage API Key');
    }
    if (newsApiKey.isEmpty || newsApiKey.contains('YOUR_')) {
      missing.add('NewsAPI Key');
    }

    return 'Missing API Keys: ${missing.join(', ')}\n\n'
        'Please update lib/core/config/api_keys.dart with your real API keys.\n'
        'Instructions are provided in the file.';
  }
}
