# AnatomyAR

AnatomyAR is an iOS learning app for exploring the heart, brain, and lungs. It combines short lessons, quizzes, 3D models, augmented reality, saved structures, progress tracking, reminders, widgets, and Live Activities.

## Main features

- Email and password accounts
- Anatomy lessons and quizzes
- Interactive RealityKit models
- AR organ placement and hotspots
- Saved anatomy structures
- Offline progress using Core Data
- Firebase progress sync
- Study reminders
- Home Screen widget
- Live Activity study timer
- Face ID or Touch ID lock

## Requirements

- Xcode with the iOS 27 SDK
- An iOS 27 simulator or device
- A Firebase project

## Project setup

1. Clone the repository.
2. Open `NIBM IOS Final.xcodeproj`.
3. Wait for Swift Package Manager to download the Firebase packages.
4. Add the Firebase configuration described below.
5. Select the `MyApp` scheme.
6. Choose an iPhone simulator or connected device and run the app.

## Firebase setup

The real `GoogleService-Info.plist` is not stored in Git because it contains Firebase project configuration. A sample file is available at `GoogleService-Info.plist.example`.

To connect the app to Firebase:

1. Create or open a Firebase project.
2. Add an iOS app using the bundle identifier from the `MyApp` target.
3. Download `GoogleService-Info.plist`.
4. Place it at `MyApp/GoogleService-Info.plist`.
5. Confirm that the file belongs to the `MyApp` target in Xcode.
6. Enable Email/Password authentication.
7. Create a Cloud Firestore database.

The app uses these Firestore paths:

- `users/{userID}` for the learner profile
- `users/{userID}/study/progress` for lessons, favourites, and quiz scores

Recommended Firestore rules:

```text
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;

      match /{document=**} {
        allow read, write: if request.auth != null
                           && request.auth.uid == userId;
      }
    }
  }
}
```

## Backend access for marking

The app allows a marker to create a new account using any valid email address. If a prepared demo account is needed, its login details and the Firebase configuration will be shared privately through the LMS submission. Passwords and Firebase configuration are not stored in this repository.

## Tests

The project includes Swift Testing unit tests for:

- Lesson completion and progress
- Quiz scores
- Saved structures
- Progress reset behaviour
- Lesson status symbols
- Quiz answer data
- Anatomy structure records

Select an iOS simulator and choose **Product > Test** in Xcode to run them.
