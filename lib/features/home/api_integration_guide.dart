import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../routing/route_names.dart';

/// Guide for integrating real APIs with the Synq app
class ApiIntegrationGuide extends StatelessWidget {
  const ApiIntegrationGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration Guide'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Real API Integration Guide',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow these steps to replace mock data with real APIs:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // YouTube API
            _buildApiSection(
              context,
              title: '1️⃣ YouTube Data API v3',
              description:
                  'Get trending YouTube videos with thumbnails and metadata',
              steps: [
                'Go to: https://cloud.google.com/docs/authentication/api-keys',
                'Create a new project in Google Cloud Console',
                'Enable YouTube Data API v3',
                'Create an API key',
                'Copy the key to lib/core/services/youtube_api_service.dart:',
                '  static const String _apiKey = "YOUR_API_KEY_HERE";',
              ],
              features: [
                'Trending videos with thumbnails',
                'View counts, likes, comments',
                'Channel information',
                'Video descriptions',
              ],
              fileLocation: 'lib/core/services/youtube_api_service.dart',
              apiKeyLine: '_apiKey',
            ),
            const SizedBox(height: 24),

            // Alpha Vantage API
            _buildApiSection(
              context,
              title: '2️⃣ Alpha Vantage (Stock Market)',
              description: 'Real-time stock prices and market data',
              steps: [
                'Go to: https://www.alphavantage.co',
                'Sign up for a free account',
                'Get your API key from the dashboard',
                'Copy the key to lib/core/services/stock_api_service.dart:',
                '  static const String _apiKey = "YOUR_API_KEY_HERE";',
                'Free tier: 5 requests per minute, 500 per day',
              ],
              features: [
                'Stock quotes and pricing',
                'Top gainers/losers',
                'Intraday time series',
                'Volume and change data',
              ],
              fileLocation: 'lib/core/services/stock_api_service.dart',
              apiKeyLine: '_apiKey',
            ),
            const SizedBox(height: 24),

            // NewsAPI
            _buildApiSection(
              context,
              title: '3️⃣ NewsAPI (Political News)',
              description: 'Breaking news and political headlines',
              steps: [
                'Go to: https://newsapi.org',
                'Sign up for a free account',
                'Get your API key',
                'Copy the key to lib/core/services/political_news_api_service.dart:',
                '  static const String _newsApiKey = "YOUR_API_KEY_HERE";',
                'Free tier: 100 requests per day',
              ],
              features: [
                'Political news headlines',
                'Search by topic',
                'Images for articles',
                'Source and author information',
              ],
              fileLocation: 'lib/core/services/political_news_api_service.dart',
              apiKeyLine: '_newsApiKey',
            ),
            const SizedBox(height: 24),

            // Implementation Steps
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 Implementation Steps',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStep(
                    '1. Get API Keys',
                    'Follow the steps above to obtain API keys from each service',
                  ),
                  _buildStep(
                    '2. Update Service Files',
                    'Replace mock API keys with real ones in the three service files',
                  ),
                  _buildStep(
                    '3. Test Individual APIs',
                    'Navigate to Trend Sync screen and click individual sync buttons',
                  ),
                  _buildStep(
                    '4. Sync All Trends',
                    'Click "Sync All Trends" to populate Firestore with real data',
                  ),
                  _buildStep(
                    '5. View Trends',
                    'Navigate to YouTube/Stock/Political screens to see real data',
                  ),
                  _buildStep(
                    '6. Refresh Feed',
                    'Pull down to refresh and see live updates',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 Tips & Best Practices',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip(
                      'Keep API keys in environment variables, not hardcoded'),
                  _buildTip('Monitor API rate limits to avoid hitting quotas'),
                  _buildTip('Use error handling for graceful degradation'),
                  _buildTip('Cache responses to reduce API calls'),
                  _buildTip(
                      'Consider using Cloud Functions for scheduled sync'),
                  _buildTip('Test with small datasets first before full sync'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Links
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔗 Quick Links',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLink(
                    'YouTube API Docs',
                    'https://developers.google.com/youtube/v3',
                  ),
                  _buildLink(
                    'Alpha Vantage Docs',
                    'https://www.alphavantage.co/documentation/',
                  ),
                  _buildLink(
                    'NewsAPI Docs',
                    'https://newsapi.org/docs',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Go to Sync Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.trendSync),
                icon: const Icon(Icons.cloud_sync),
                label: const Text('Go to Sync Screen'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildApiSection(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> steps,
    required List<String> features,
    required String fileLocation,
    required String apiKeyLine,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          const Text(
            'Setup Steps:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.only(top: 6, left: 8),
                child: Text(
                  '• $step',
                  style: const TextStyle(fontSize: 12),
                ),
              )),
          const SizedBox(height: 12),
          const Text(
            'Features:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(top: 6, left: 8),
                child: Text(
                  '✓ $feature',
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('→ ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLink(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          '🔗 $label',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.purple,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
