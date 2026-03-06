# Firestore Security Rules Deployment

The app requires proper Firestore security rules to function correctly. The `firestore.rules` file has been created with the following security policy:

## Security Rules Summary:

- **Users collection**: Authenticated users can read/write their own documents
- **Trends collection**: Authenticated users can read, admins only can write
- **Posts collection**: Authenticated users can read all, write their own
- **Reports collection**: Authenticated users can read all, write their own

## How to Deploy:

### Option 1: Using Firebase Console (Easiest)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project `synq-d18b1`
3. Go to Firestore Database → Rules tab
4. Copy the rules from `firestore.rules` file in this directory
5. Paste into the Firebase Console Rules editor
6. Click "Publish"

### Option 2: Using Firebase CLI (If installed)

```bash
firebase deploy --only firestore:rules
```

## Current Issues Fixed:

✅ Created proper security rules that allow authenticated users to log in and access their data
✅ Fixed login screen to handle updateDisplayName errors gracefully
✅ Improved error handling in AuthProvider

## After Deploying Rules:

The app should work correctly:

1. Users can register new accounts
2. Users can log in with existing credentials
3. App will remember logged-in users
4. Trends will load from Firestore
5. Users can create posts and reports
