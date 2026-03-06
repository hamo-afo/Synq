# Real API Integration Guide

## Overview

The Synq app now integrates with three real APIs to fetch trending data:

1. **YouTube Data API v3** - Trending videos
2. **Alpha Vantage** - Stock market trends
3. **NewsAPI** - Political news

## Quick Setup (5 minutes)

### Step 1: Get Your API Keys

#### YouTube Data API v3

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project
3. Search for "YouTube Data API v3" and enable it
4. Go to Credentials → Create API Key
5. Copy your key

#### Alpha Vantage (Stocks)

1. Visit [Alpha Vantage](https://www.alphavantage.co/api/)
2. Enter your email and get a free API key
3. Copy the key from confirmation email

#### NewsAPI (Political News)

1. Visit [NewsAPI](https://newsapi.org)
2. Click "Get API Key"
3. Sign up and copy your key from dashboard

### Step 2: Add Keys to Your Project

1. Open: `lib/core/config/api_keys.dart`
2. Replace the placeholder values:

```dart
class ApiKeys {
  static const String youtubeApiKey = 'YOUR_YOUTUBE_KEY_HERE';
  static const String alphaVantageApiKey = 'YOUR_ALPHA_VANTAGE_KEY_HERE';
  static const String newsApiKey = 'YOUR_NEWS_API_KEY_HERE';
}
```

3. Save and restart the app

### Step 3: Run the App

```bash
flutter run
```

The app will automatically fetch real data from all three APIs on launch.

## API Details

### YouTube Data API v3

- **Endpoint**: Trending videos in your region
- **Data**: Video title, channel, views, likes, thumbnail URL
- **Free Quota**: 10,000 units/day (enough for 666 requests)
- **Documentation**: https://developers.google.com/youtube/v3

### Alpha Vantage

- **Endpoint**: Top gainers/losers stocks
- **Data**: Stock symbol, price, change %, volume
- **Free Tier**: 5 requests/minute, 500 requests/day
- **Documentation**: https://www.alphavantage.co/documentation/

### NewsAPI

- **Endpoint**: Political news articles
- **Data**: Title, description, source, image URL, article link
- **Free Tier**: 1,000 requests/month
- **Documentation**: https://newsapi.org/docs

## Error Handling

If API keys are not configured, the app will show:

- A clear error message on the home screen
- Links to obtain your API keys
- Instructions for setup

If an API fails to load:

- The app continues with available data
- Errors are logged to console
- Users can retry from the drawer menu

## Testing Without Real Keys

For development/testing purposes, you can use the mock data generator:

```dart
// In lib/features/home/home_screen.dart
// Replace real API calls with:
await MockTrendDataGenerator().generateAllMockTrends();
```

## Rate Limits & Best Practices

### YouTube

- Cache results for at least 1 hour
- Don't request more than 20 items per API call
- Limit regional requests to reduce quota usage

### Alpha Vantage

- Wait 1 minute between requests for same symbol
- Use the free tier for personal/development use
- Consider upgrading for production

### NewsAPI

- Monitor monthly request count
- Cache results to reduce API calls
- Use pagination for large datasets

## Troubleshooting

### "Invalid API Key"

- Check you copied the entire key
- Ensure no extra spaces in api_keys.dart
- Verify key is enabled in respective API dashboard

### "Rate Limit Exceeded"

- Wait before making new requests
- Check if you've exceeded free tier limits
- Consider upgrading to paid plans

### "No data returned"

- Verify internet connection
- Check Firebase is properly initialized
- Review console logs for error messages

## File Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_keys.dart          ← Update with your keys
│   └── services/
│       ├── youtube_api_service.dart
│       ├── stock_api_service.dart
│       ├── political_news_api_service.dart
│       └── api_trend_fetcher.dart
├── features/
│   └── home/
│       ├── home_screen.dart        ← Auto-fetches on init
│       ├── api_setup_guide.dart    ← User-facing setup guide
│       └── trend_feed.dart         ← Displays fetched data
└── data/
    └── repositories/
        └── trend_repository.dart   ← Queries Firestore
```

## Next Steps

1. **Get API Keys** - Follow the setup steps above
2. **Add Keys** - Update api_keys.dart
3. **Run App** - `flutter run`
4. **Test** - Go to each category screen to see real data
5. **Deploy** - Keep keys secure in production

## Security Notes

⚠️ **Never commit API keys to version control**

For production:

- Use environment variables
- Use Firebase Remote Config
- Implement backend proxy for API calls
- Rotate keys regularly

## Support

For API-specific issues:

- YouTube: https://support.google.com/youtube/
- Alpha Vantage: https://www.alphavantage.co/support/
- NewsAPI: https://newsapi.org/docs

For app issues:

- Check console logs
- Review error messages
- Try the "API Setup" screen from drawer
