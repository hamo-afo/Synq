// lib/features/home/api_setup_guide.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/api_keys.dart';

class ApiSetupGuide extends StatelessWidget {
  const ApiSetupGuide({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Setup Guide')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configure Your API Keys',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This app requires three API keys to fetch real trending data. Follow the steps below to set them up:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildApiSection(
              title: '1. YouTube Data API v3',
              description:
                  'Get real-time trending YouTube videos in your region',
              steps: [
                'Go to Google Cloud Console: https://console.cloud.google.com',
                'Create a new project (or select existing)',
                'Search for "YouTube Data API v3" and enable it',
                'Go to Credentials tab',
                'Click "Create Credentials" → "API Key"',
                'Copy your API key',
              ],
              onSetup: () =>
                  _launchUrl('https://console.cloud.google.com/apis/library'),
            ),
            const SizedBox(height: 20),
            _buildApiSection(
              title: '2. Alpha Vantage (Stock Market API)',
              description: 'Get trending stocks and market data',
              steps: [
                'Go to https://www.alphavantage.co/api/',
                'Enter your email address',
                'Accept terms and click "GET FREE API KEY"',
                'You\'ll receive your API key via email',
                'Copy and save your API key',
              ],
              onSetup: () => _launchUrl('https://www.alphavantage.co/api/'),
            ),
            const SizedBox(height: 20),
            _buildApiSection(
              title: '3. NewsAPI (Political News)',
              description: 'Get latest political news articles',
              steps: [
                'Go to https://newsapi.org',
                'Click "Get API Key"',
                'Sign up with your email',
                'Copy your API key from the dashboard',
              ],
              onSetup: () => _launchUrl('https://newsapi.org'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How to Add Your Keys',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Open file: lib/core/config/api_keys.dart',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2. Replace the placeholder values:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey.shade200,
                    child: const Text(
                      'youtubeApiKey = \'YOUR_KEY_HERE\';\n'
                      'alphaVantageApiKey = \'YOUR_KEY_HERE\';\n'
                      'newsApiKey = \'YOUR_KEY_HERE\';',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '3. Save the file and restart the app',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please edit lib/core/config/api_keys.dart with your API keys',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open File in Editor'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildApiSection({
    required String title,
    required String description,
    required List<String> steps,
    required VoidCallback onSetup,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        ...steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${entry.key + 1}. ${entry.value}',
              style: const TextStyle(fontSize: 12),
            ),
          );
        }),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: onSetup,
          icon: const Icon(Icons.open_in_browser),
          label: const Text('Visit Website'),
        ),
      ],
    );
  }
}
