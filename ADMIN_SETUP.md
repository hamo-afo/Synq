# Admin setup

You chose Option 1 (pre-registered admin). Two ways to mark `hamoafo@gmail.com` as admin:

Quick (recommended for now)

1. Open Firebase Console -> Firestore Database -> Data
2. Open `users` collection and find the document for the user (or create it if missing).
3. Add or edit the field `isAdmin` (boolean) and set it to `true`.

This will allow the app (and the Firestore rules we added) to treat that user as admin.

Safer (uses custom claims - recommended long-term)

1. Use Firebase Admin SDK on a secure server or your local machine with service account credentials.
2. Example Node script (run once):

```js
const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

async function setAdmin(uid) {
  await admin.auth().setCustomUserClaims(uid, { admin: true });
  console.log("Custom claim set for", uid);
}

// lookup user by email, then set claim
admin
  .auth()
  .getUserByEmail("hamoafo@gmail.com")
  .then((user) => setAdmin(user.uid))
  .catch(console.error);
```

3. After setting custom claim, update your Firestore rules to check `request.auth.token.admin == true` instead of reading `users/{uid}`.

Notes

- After you set `isAdmin: true` in Firestore (quick method), the user may need to sign out and sign back in to refresh their local `AuthProvider` data.
- For maximum security, prefer custom claims + Admin SDK.
