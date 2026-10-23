# AnatomyAR

An iOS anatomy learning app built with SwiftUI, RealityKit, Firebase Authentication, Cloud Firestore, widgets, Live Activities, and Swift Testing.

## Requirements

- Xcode with the iOS 27 SDK
- An iOS 27 simulator or device
- A Firebase project for login and cloud progress

## Firebase setup

The real `GoogleService-Info.plist` is intentionally not stored in Git because it contains project configuration and an API key. The developer's local file remains in place, so the existing local project continues to work.

To configure a new machine:

1. Open the Firebase Console and select the Firebase project.
2. Register an iOS app using the bundle identifier from the Xcode target.
3. Download `GoogleService-Info.plist`.
4. Copy it to `MyApp/GoogleService-Info.plist`.
5. In Xcode, confirm the file belongs to the `MyApp` target and is included in **Copy Bundle Resources**.
6. Enable **Email/Password** in Firebase Authentication.
7. Create a Cloud Firestore database.
8. Open the project, allow Swift Package Manager to resolve the Firebase packages, and run the `MyApp` scheme.

`GoogleService-Info.plist.example` shows the expected file shape but contains no working credentials.

## Firestore data

The app creates its data after registration:

- `users/{userID}` stores the learner name, email, study level, and daily goal.
- `users/{userID}/study/progress` stores completed lessons, saved structures, and best quiz scores.

Firestore rules should allow authenticated users to read and write only their own document:

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## Marker access

The marker can create a new account from the app because Email/Password registration is enabled. If a prepared demonstration account is required, provide its email and password privately through the LMS submission notes or directly to the lecturer. Do not put passwords in GitHub.

The repository owner must also add the lecturer's GitHub account as a collaborator because this repository is private.

## Tests

Select an iOS simulator and run tests with **Product > Test** in Xcode. The Swift Testing suite checks lesson progress, quiz scores, favourites, model data, and lesson structure records.

## Submission

Use a link to the final commit in this format:

```text
https://github.com/Ad4mrr/NIBM-IOS-Final/commit/FINAL_COMMIT_SHA
```

Do not use a branch link for the final report.
