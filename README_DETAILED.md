# Synq - Trends & Reports Aggregation Platform

**Stay ahead of the trends** - A comprehensive Flutter application that aggregates trending data from multiple sources (YouTube, stock markets, and political news) with real-time analytics and reporting capabilities.

## 📋 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Technical Stack](#technical-stack)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [API Integration](#api-integration)
- [Database Schema](#database-schema)
- [Routing & Navigation](#routing--navigation)
- [Authentication](#authentication)
- [Admin Features](#admin-features)
- [Screenshots & UI](#screenshots--ui)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**Synq** is a Flutter-based mobile application designed to help users stay informed about trending topics across multiple domains. It combines data from three major sources:

1. **YouTube API** - Trending videos and entertainment content
2. **Alpha Vantage** - Stock market trends and financial data
3. **NewsAPI** - Political news and current events

The app provides:

- Real-time trend aggregation
- Advanced search and filtering
- Detailed analytics and reporting
- User engagement features (likes, comments, discussions)
- Admin dashboard for content management
- Firebase backend with Firestore database

---

## ✨ Key Features

### 👤 User Features

| Feature            | Description                                                          |
| ------------------ | -------------------------------------------------------------------- |
| **Authentication** | Firebase-based login & registration with email/password              |
| **Trend Feed**     | Real-time aggregated trends from YouTube, stocks, and political news |
| **Category Views** | Separate dedicated screens for each trend category                   |
| **Trend Search**   | Full-text search across all trends with real-time filters            |
| **Trend Details**  | Detailed view with rich information, images, and external links      |
| **Engagement**     | Like trends and post comments to create discussions                  |
| **User Posts**     | Create custom posts and comments on trends                           |
| **Responsive UI**  | Dark/Light theme support with smooth animations                      |

### 📊 Analytics & Reports

- **Daily Reports** - Trend statistics and engagement metrics
- **Weekly Reports** - Aggregated weekly data and patterns
- **Monthly Reports** - Long-term trend analysis
- **Data Visualization** - Charts showing trend distribution and trends over time
- **CSV Export** - Export reports in CSV format for external analysis
- **Top Gainers/Losers** - Stock market trending analysis
- **Trending Keywords** - Most discussed topics

### 🛡️ Admin Features

| Feature               | Description                                     |
| --------------------- | ----------------------------------------------- |
| **Admin Dashboard**   | Central hub for all admin operations            |
| **Trend Management**  | Add, edit, delete, and sync trends              |
| **User Management**   | View users, manage permissions, ban users       |
| **Database Viewer**   | Browse and inspect Firestore collections        |
| **Sync Controls**     | Manually trigger API data synchronization       |
| **Report Generation** | Create custom reports with flexible date ranges |
| **Analytics**         | Monitor app usage and engagement metrics        |

---

## 🛠 Technical Stack

### Frontend

- **Framework**: Flutter 3.5+
- **State Management**: Provider (GetIt for services)
- **UI Framework**: Material Design 3
- **Charts**: FL Chart (for data visualization)
- **Image Handling**: Cached Network Image, Image Picker

### Backend & Services

- **Authentication**: Firebase Authentication
- **Database**: Firebase Firestore (NoSQL)
- **Storage**: Firebase Cloud Storage
- **Real-time Sync**: Firestore Listeners & Streams

### External APIs

- **YouTube Data API v3** - Trending video content
- **Alpha Vantage** - Stock market data
- **NewsAPI** - Political news and articles

### Development Tools

- **Package Manager**: Pub
- **Database Diagram**: Python (included in `/tools`)
- **Report Generation**: Python (PDF conversion utilities)

### Dependencies

```yaml
# Core
flutter: sdk
cupertino_icons: ^1.0.8

# Firebase
firebase_core: ^2.20.0
firebase_auth: ^4.6.4
cloud_firestore: ^4.17.5
firebase_storage: ^11.2.7

# State Management & Utils
provider: ^6.1.5
fluttertoast: ^8.2.2
intl: ^0.18.1
shared_preferences: ^2.3.2

# Media & UI
image_picker: ^1.1.2
cached_network_image: ^3.4.1
shimmer: ^2.0.0
flutter_svg: ^2.0.10+1

# Networking
http: ^1.2.2
connectivity_plus: ^6.1.0

# Tools
url_launcher: ^6.3.0
fl_chart: ^0.68.0
csv: ^6.0.0
```

---

## 📁 Project Structure

```
synq/
├── lib/
│   ├── main.dart                    # App entry point & root widget
│   ├── firebase_options.dart        # Firebase configuration
│   │
│   ├── core/                        # Core functionality & services
│   │   ├── config/
│   │   │   └── api_keys.dart       # External API keys (⚠️ secure!)
│   │   ├── constants/
│   │   │   └── ...                 # App-wide constants
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── admin_service.dart
│   │   │   ├── api_trend_fetcher.dart
│   │   │   ├── youtube_api_service.dart
│   │   │   ├── stock_api_service.dart
│   │   │   └── political_news_api_service.dart
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── ...
│   │
│   ├── data/                        # Data layer (models & repositories)
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── trend_model.dart
│   │   │   └── post_model.dart
│   │   └── repositories/
│   │       ├── trend_repository.dart
│   │       ├── report_repository.dart
│   │       └── user_repository.dart
│   │
│   ├── features/                    # Feature modules (UI + Logic)
│   │   ├── auth/                    # Authentication screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   │   └── widgets/
│   │   │       └── auth_textfield.dart
│   │   │
│   │   ├── home/                    # Main dashboard
│   │   │   ├── home_screen.dart
│   │   │   ├── trend_feed.dart
│   │   │   ├── dashboard_drawer.dart
│   │   │   ├── api_integration_guide.dart
│   │   │   └── api_setup_guide.dart
│   │   │
│   │   ├── trends/                  # Trend screens & management
│   │   │   ├── youtube_trends_screen.dart
│   │   │   ├── stock_trends_screen.dart
│   │   │   ├── political_trends_screen.dart
│   │   │   ├── trend_search_screen.dart
│   │   │   ├── trend_detail_screen.dart
│   │   │   └── trend_sync_screen.dart
│   │   │
│   │   ├── posts/                   # User posts & discussions
│   │   │   ├── add_post_screen.dart
│   │   │   └── ...
│   │   │
│   │   ├── reports/                 # Analytics & reporting
│   │   │   └── reports_screen.dart
│   │   │
│   │   ├── admin/                   # Admin panel features
│   │   │   ├── admin_dashboard.dart
│   │   │   ├── admin_panel_screen.dart
│   │   │   ├── user_management.dart
│   │   │   ├── database_viewer.dart
│   │   │   ├── generate_report_button.dart
│   │   │   └── add_post_screen.dart
│   │   │
│   │   ├── settings/                # App settings
│   │   │   └── settings_screen.dart
│   │   │
│   │   └── providers/               # State management
│   │       └── auth_provider.dart
│   │
│   ├── routing/                     # Navigation configuration
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   │
│   ├── theme/                       # UI theme configuration
│   │   └── theme.dart
│   │
│   └── widgets/                     # Reusable UI components
│       ├── trend_card.dart
│       ├── custom_button.dart
│       └── ...
│
├── android/                         # Android native code
├── ios/                            # iOS native code
├── web/                            # Web deployment files
├── assets/                         # Images, icons, SVG files
│
├── pubspec.yaml                    # Package dependencies
├── firebase.json                   # Firebase configuration
├── firestore.rules                 # Firestore security rules
├── analysis_options.yaml           # Dart analysis configuration
├── DATABASE_DESIGN.md              # Database schema documentation
├── API_INTEGRATION_README.md       # API setup guide
└── README.md                       # Quick start guide
```

---

## 🏗 Architecture

### Layered Architecture

The app follows a **Clean Architecture** pattern with separation of concerns:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│  (Screens, Widgets, UI Components)  │
└────────────────┬────────────────────┘
                 │
         Provider (State Management)
                 │
┌────────────────▼────────────────────┐
│          Feature Modules            │
│   (Business Logic & Use Cases)      │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│         Data Access Layer           │
│  (Repositories, API Services)       │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│      External Services              │
│  (Firebase, APIs, Local Storage)    │
└─────────────────────────────────────┘
```

### Data Flow

1. **User Interaction** → Triggers action in UI (Screen/Widget)
2. **State Management** → Provider notifies listeners of state changes
3. **Repository** → Fetches data from APIs or Firestore
4. **Services** → Handle specific business logic (auth, trends, etc.)
5. **External APIs** → YouTube, Alpha Vantage, NewsAPI, Firebase
6. **UI Update** → Listeners rebuild with new data

### Authentication Flow

```
┌─────────────────┐
│   SplashScreen  │
│  (Check Auth)   │
└────────┬────────┘
         ▼
    ┌─────────┐
    │ Logged  │ ────Yes───→ [Home Screen]
    │ In?     │
    └────┬────┘
         │No
         ▼
   [Login/Register]
         │ (Success)
         ▼
   [Create User Doc]
         │
         ▼
   [Home Screen]
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.5.0 or higher
- **Dart SDK**: 3.5.0 or higher
- **Git**: For version control
- **Android Studio** or **Xcode**: For mobile development
- **Firebase Account**: For backend services
- **API Keys**: YouTube, Alpha Vantage, NewsAPI

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/synq.git
cd synq
```

#### 2. Set Up Firebase

- Go to [Firebase Console](https://console.firebase.google.com/)
- Create a new project
- Add Android and iOS apps
- Download configuration files:
  - `google-services.json` → `android/app/`
  - `GoogleService-Info.plist` → `ios/Runner/`

#### 3. Configure Environment

```bash
# (Optional) Set Flutter to latest stable
flutter channel stable
flutter upgrade

# Get dependencies
flutter pub get

# (Optional) Generate build runner files if using code generation
flutter pub run build_runner build
```

#### 4. Add API Keys

Create or edit `lib/core/config/api_keys.dart`:

```dart
class ApiKeys {
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String alphaVantageApiKey = 'YOUR_ALPHA_VANTAGE_KEY';
  static const String newsApiKey = 'YOUR_NEWS_API_KEY';
}
```

#### 5. Run the App

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d web

# Run on specific device
flutter devices
flutter run -d <device_id>
```

---

## 🔗 API Integration

### YouTube Data API v3

**Purpose**: Fetch trending video content

**Setup**:

1. Visit [Google Cloud Console](https://console.cloud.google.com)
2. Create a project → Search "YouTube Data API v3" → Enable
3. Go to Credentials → Create API Key
4. Copy to `api_keys.dart`

**Rate Limits**: 10,000 units/day (≈ 666 requests)

**Implementation**: [youtube_api_service.dart](lib/core/services/youtube_api_service.dart)

### Alpha Vantage

**Purpose**: Stock market trends and financial data

**Setup**:

1. Visit [Alpha Vantage](https://www.alphavantage.co/api/)
2. Enter email → Receive key via email
3. Copy to `api_keys.dart`

**Rate Limits**: 5 requests/minute, 500 requests/day (free tier)

**Implementation**: [stock_api_service.dart](lib/core/services/stock_api_service.dart)

### NewsAPI

**Purpose**: Political news and current events

**Setup**:

1. Visit [NewsAPI](https://newsapi.org)
2. Sign up → Get API key from dashboard
3. Copy to `api_keys.dart`

**Rate Limits**: 1,000 requests/month (free tier)

**Implementation**: [political_news_api_service.dart](lib/core/services/political_news_api_service.dart)

### API Fetching & Caching

The `ApiTrendFetcher` service:

- Fetches from all three APIs
- Transforms data to `TrendModel`
- Saves to Firestore (auto-sync with app)
- Implements retry logic and timeout handling
- Preserves user engagement data (likes, comments)

---

## 🗄 Database Schema

### Collections Overview

#### 1. **users** Collection

Stores user profiles and authentication metadata.

| Field       | Type      | Required | Description                     |
| ----------- | --------- | -------- | ------------------------------- |
| `uid`       | String    | ✓        | Firebase Auth UID (document ID) |
| `name`      | String    | ✓        | User's display name             |
| `email`     | String    | ✓        | User's email address            |
| `role`      | String    | ✓        | `'user'` or `'admin'`           |
| `createdAt` | Timestamp | ✓        | Account creation date           |
| `isAdmin`   | Boolean   | ✗        | Admin privilege flag            |
| `banned`    | Boolean   | ✗        | Ban status for moderation       |

**Firestore Indexes**:

- `email` (ascending)
- `isAdmin` (ascending)
- `banned` (ascending)

**Security Rules**: Read/Write only by own document or admin

#### 2. **trends** Collection

Stores aggregated trending items from APIs.

| Field         | Type      | Required | Description                              |
| ------------- | --------- | -------- | ---------------------------------------- |
| `id`          | String    | ✓        | Unique identifier from source API        |
| `type`        | String    | ✓        | `'youtube'`, `'stock'`, or `'political'` |
| `title`       | String    | ✓        | Trend title/name                         |
| `description` | String    | ✓        | Detailed description                     |
| `summary`     | String    | ✗        | Short summary                            |
| `date`        | Timestamp | ✓        | When trend was recorded                  |
| `source`      | String    | ✓        | Original API source                      |
| `category`    | String    | ✗        | Trend category                           |
| `imageUrl`    | String    | ✗        | Image/thumbnail URL                      |
| `link`        | String    | ✗        | External link to source                  |
| `likes`       | Integer   | ✗        | User engagement counter                  |
| `views`       | Integer   | ✗        | View count                               |
| `uploadedBy`  | String    | ✗        | User who added trend                     |
| `extras`      | Map       | ✗        | Additional metadata from API             |

**Firestore Indexes**:

- Composite: `date` (desc), `likes` (desc)
- Composite: `type` (asc), `date` (desc)
- Single: `date` (desc)

**Security Rules**: Read - authenticated users; Write - admin only

#### 3. **posts** Collection

User-created posts and discussions about trends.

| Field       | Type      | Required | Description                 |
| ----------- | --------- | -------- | --------------------------- |
| `userId`    | String    | ✓        | Creator's Firebase Auth UID |
| `title`     | String    | ✓        | Post title                  |
| `content`   | String    | ✓        | Post body content           |
| `createdAt` | Timestamp | ✓        | Creation date               |
| `likes`     | Integer   | ✗        | Like count (default: 0)     |
| `comments`  | Integer   | ✗        | Comment count (default: 0)  |
| `tags`      | Array     | ✗        | Topic tags                  |

**Sub-collection**: `posts/{postId}/comments`

| Field       | Type      | Required | Description             |
| ----------- | --------- | -------- | ----------------------- |
| `userId`    | String    | ✓        | Comment author UID      |
| `content`   | String    | ✓        | Comment text            |
| `createdAt` | Timestamp | ✓        | Creation date           |
| `likes`     | Integer   | ✗        | Like count (default: 0) |

**Firestore Indexes**:

- Composite: `createdAt` (desc), `likes` (desc)

**Security Rules**:

- Read: Authenticated users
- Write: Author only (or admin)
- Delete: Author or admin

### Detailed ER Diagram

See [DATABASE_DESIGN.md](DATABASE_DESIGN.md) for complete schema documentation with visual diagrams.

---

## 🧭 Routing & Navigation

### Route Structure

Routes are centrally managed in `routing/route_names.dart` and `routing/app_router.dart`:

| Route               | Screen                | Purpose                |
| ------------------- | --------------------- | ---------------------- |
| `/splash`           | SplashScreen          | Initial auth check     |
| `/login`            | LoginScreen           | User login             |
| `/register`         | RegisterScreen        | User registration      |
| `/forgot-password`  | ForgotPasswordScreen  | Password reset         |
| `/home`             | HomeScreen            | Main dashboard         |
| `/youtube-trends`   | YouTubeTrendsScreen   | YouTube category view  |
| `/stock-trends`     | StockTrendsScreen     | Stock trends view      |
| `/political-trends` | PoliticalTrendsScreen | Political news view    |
| `/trend-sync`       | TrendSyncScreen       | Admin sync tool        |
| `/trend-search`     | TrendSearchScreen     | Search & filter trends |
| `/admin/dashboard`  | AdminDashboard        | Admin control panel    |
| `/admin/users`      | UserManagementScreen  | User management        |
| `/reports/admin`    | ReportsScreen         | Analytics & reports    |
| `/settings`         | SettingsScreen        | App settings           |

### Navigation Example

```dart
// Navigate to a route
Navigator.pushNamed(context, RouteNames.trendSearch);

// Navigate with replacement (back button behavior)
Navigator.pushReplacementNamed(context, RouteNames.home);

// Go back
Navigator.pop(context);

// Clear stack and navigate
Navigator.pushNamedAndRemoveUntil(
  context,
  RouteNames.home,
  (route) => false,
);
```

---

## 🔐 Authentication

### Firebase Authentication Flow

1. **User Signup**
   - Enter email, password, name
   - Firebase creates Auth account
   - App creates Firestore user document
   - User redirected to home

2. **User Login**
   - Enter email & password
   - Firebase validates credentials
   - AuthProvider loads user data from Firestore
   - User redirected to home

3. **Session Persistence**
   - Firebase auto-restores session on app restart
   - SplashScreen checks auth status
   - Routes to home (logged in) or login (not logged in)

4. **Password Reset**
   - User enters email
   - Firebase sends reset link
   - User creates new password

### AuthProvider (State Management)

```dart
class AuthProvider extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  Future<void> loadCurrentUser() { /* ... */ }
  Future<UserModel> login(String email, String password) { /* ... */ }
  Future<UserModel> register(String name, String email, String password) { /* ... */ }
  Future<void> sendPasswordReset(String email) { /* ... */ }
  Future<void> signOut() { /* ... */ }
}

// Usage in Widget
final authProvider = Provider.of<AuthProvider>(context);
if (authProvider.isLoading) {
  return LoadingWidget();
}
if (authProvider.user == null) {
  Navigator.pushReplacementNamed(context, RouteNames.login);
}
```

---

## 👨‍💼 Admin Features

### Admin Dashboard

Access via: **Menu → Admin Dashboard** (admin-only)

**Features**:

| Feature              | Description                                   |
| -------------------- | --------------------------------------------- |
| **Trend Sync**       | Manually trigger API data synchronization     |
| **User Management**  | View all users, manage roles, ban/unban users |
| **Reports**          | Generate custom analytics reports             |
| **Database Viewer**  | Browse Firestore collections and documents    |
| **Posts Management** | Create, edit, delete posts/announcements      |

### Admin Privileges

Users marked as `isAdmin: true` in Firestore can:

- Add/edit/delete trends
- Manage user accounts
- Generate reports
- Access admin dashboard
- Override content moderation

### Setting Admin Privileges

**Method 1: Direct Firestore Edit**

```json
// Document: users/{uid}
{
  "isAdmin": true,
  "role": "admin"
}
```

**Method 2: Via App (Founder)**

- Founder email: `hamoafo@gmail.com`
- Opens Admin Dashboard
- Click "Claim Admin (founder)" button

**Method 3: Firebase Cloud Functions** (Optional)

- Deploy custom function to set admin for specific user
- Call from app or admin CLI

---

## 📸 Screenshots & UI

### Theme

The app uses a **Greenish-Grey Dark Theme** with emerald accents:

- **Primary Color**: `#4B7F6A` (Greenish-Grey)
- **Accent**: `#10B981` (Emerald)
- **Dark Background**: `#1A2421`
- **Status Colors**: Green (success), Amber (warning), Red (error)

### Key Screens

1. **Splash Screen**
   - App logo animation
   - Auth status check
   - Loading indicator

2. **Login/Register**
   - Email & password fields
   - Form validation
   - Social auth ready (future)

3. **Home/Dashboard**
   - Trend feed with cards
   - Search button (top)
   - Navigation drawer
   - Pull-to-refresh

4. **Trend Categories**
   - YouTube trends (with thumbnails)
   - Stock trends (with price charts)
   - Political news (with article previews)

5. **Trend Detail**
   - Full trend information
   - Image display
   - Like/comment buttons
   - External link opener

6. **Search Screen**
   - Real-time search filter
   - Multi-field search (title, description, category)
   - Filter by category/date

7. **Reports**
   - Daily/Weekly/Monthly statistics
   - Charts (bar, line, pie)
   - CSV export
   - Date range selector

8. **Admin Panel**
   - Dashboard widgets
   - User management table
   - Sync controls
   - Report generation

---

## ⚙️ Configuration

### Environment Variables

Create `.env` file (or use `api_keys.dart`):

```env
YOUTUBE_API_KEY=your_youtube_key
ALPHA_VANTAGE_API_KEY=your_alpha_vantage_key
NEWS_API_KEY=your_news_api_key
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### Firebase Configuration

**Android** (`android/app/build.gradle`):

```gradle
dependencies {
  classpath 'com.google.gms:google-services:4.3.15'
}
```

**iOS** (`ios/Podfile`):

```ruby
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
```

### Theme Customization

Edit [theme/theme.dart](lib/theme/theme.dart):

```dart
class AppTheme {
  static final Color primaryColor = Color(0xFF059669);
  // ... customize colors, sizes, margins, etc.

  static final ThemeData lightTheme = ThemeData(
    primary: primaryColor,
    // ... other theme properties
  );
}
```

### Firestore Security Rules

Edit [firestore.rules](firestore.rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users: read own doc, write only self
    match /users/{uid} {
      allow read: if request.auth.uid == uid || isAdmin();
      allow write: if request.auth.uid == uid || isAdmin();
    }

    // Trends: read all authenticated, write admin only
    match /trends/{document=**} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }

    // Posts: read all, write/delete own
    match /posts/{document=**} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if isOwner() || isAdmin();
    }

    // Helper functions
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    function isOwner() {
      return request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## 🚀 Deployment

### Android Release Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output location
# APK: build/app/outputs/apk/release/app-release.apk
# AAB: build/app/outputs/bundle/release/app-release.aab
```

### iOS Release Build

```bash
# Build IPA
flutter build ipa --release

# Output location
# IPA: build/ios/ipa/

# Or build using Xcode
open ios/Runner.xcworkspace
# Archive → Distribute App → Upload to App Store
```

### Firebase Hosting (Web)

```bash
# Build web
flutter build web --release

# Install Firebase CLI
npm install -g firebase-tools

# Deploy
firebase login
firebase init
firebase deploy --only hosting
```

### Pre-Deployment Checklist

- [ ] API keys configured correctly
- [ ] Firebase project set up (Auth, Firestore, Storage)
- [ ] Firestore security rules deployed
- [ ] App version bumped in `pubspec.yaml`
- [ ] All tests passing
- [ ] No console errors or warnings
- [ ] UI tested on multiple devices
- [ ] Offline functionality verified
- [ ] Analytics integrated (optional)
- [ ] Privacy policy updated
- [ ] Terms of service reviewed

---

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/path/to/test.dart

# Generate coverage
flutter test --coverage

# View coverage
lcov --list coverage/lcov.info
```

### Integration Tests

```bash
# Run integration tests
flutter drive --target=test_driver/app.dart

# Run on physical device
flutter drive --target=test_driver/app.dart -d <device_id>
```

### Widget Tests Example

```dart
testWidgets('Login screen displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(const SynqApp());
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.byType(TextField), findsWidgets);
});
```

---

## 📱 Supported Platforms

| Platform | Status      | Min Version             |
| -------- | ----------- | ----------------------- |
| Android  | ✓ Supported | Android 5.0 (API 21)    |
| iOS      | ✓ Supported | iOS 11.0+               |
| Web      | ✓ Supported | Chrome, Firefox, Safari |
| macOS    | ⚠ Partial   | macOS 10.11+            |
| Windows  | ⚠ Partial   | Windows 10+             |
| Linux    | ⚠ Partial   | Ubuntu 18.04+           |

---

## 🐛 Troubleshooting

### Common Issues

#### "Invalid API Key"

- Verify key is copied completely (no extra spaces)
- Ensure API is enabled in respective dashboard
- Check key hasn't expired

#### "Firebase not initialized"

- Ensure `firebase_options.dart` is generated correctly
- Run: `flutterfire configure --project=your_firebase_project`
- Check `android/build.gradle` has Google Services plugin

#### "Firestore rules rejected"

- Verify user is authenticated
- Check user `isAdmin` flag is set correctly
- Review security rules for syntax errors

#### App crashes on startup

- Check console logs: `flutter run -v`
- Ensure all dependencies are installed: `flutter pub get`
- Clear build cache: `flutter clean && flutter pub get`

#### "Rate limit exceeded" on API

- Implement exponential backoff retry logic
- Cache API responses locally
- Consider upgrading to paid tier

#### Dark theme not applying

- Set `themeMode: ThemeMode.dark` in `main.dart`
- Clear app cache: `flutter clean`
- Rebuild app

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** changes: `git commit -m 'Add amazing feature'`
4. **Push** to branch: `git push origin feature/amazing-feature`
5. **Submit** a Pull Request

### Contribution Guidelines

- Follow Flutter best practices and Dart style guide
- Write clear, descriptive commit messages
- Add tests for new features
- Update documentation as needed
- Ensure code passes analysis: `flutter analyze`

### Code Style

```bash
# Format code
dart format lib/

# Run linter
flutter analyze

# Fix linter issues (auto)
dart fix --apply
```

---

## 📄 License

This project is licensed under the **MIT License** - see [LICENSE](LICENSE) file for details.

---

## 📞 Support & Contact

**Author**: Hamza Afo

**Email**: [hamoafo@gmail.com](mailto:hamoafo@gmail.com)

**Issues & Bugs**: [GitHub Issues](https://github.com/yourusername/synq/issues)

**Feature Requests**: [GitHub Discussions](https://github.com/yourusername/synq/discussions)

---

## 🙏 Acknowledgments

- **Flutter Team** - Amazing framework
- **Firebase** - Backend infrastructure
- **API Providers** - Data sources (YouTube, Alpha Vantage, NewsAPI)
- **Community** - Support and contributions

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)
- [Provider Package](https://pub.dev/packages/provider)

---

## 🔄 Version History

### v1.0.0 (Current)

- ✓ Core authentication system
- ✓ Multi-source trend aggregation (YouTube, Stocks, Political News)
- ✓ Real-time Firestore sync
- ✓ Search and filtering
- ✓ Reports and analytics
- ✓ Admin dashboard
- ✓ User post management
- ✓ Dark/Light themes

### Future Roadmap

- [ ] Social features (follow users, feed personalization)
- [ ] Push notifications
- [ ] Offline mode enhancements
- [ ] Mobile app optimizations
- [ ] AI-powered recommendations
- [ ] Advanced charting and analytics
- [ ] Export to PDF reports
- [ ] Multi-language support

---

**Last Updated**: March 31, 2026 | **Maintained By**: Hamza Afo
