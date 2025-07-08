# Notes App - Individual Assignment 2

A Flutter notes application with Firebase authentication and Firestore database integration, implementing clean architecture and BLoC state management.

## Architecture Overview

The app follows clean architecture principles with clear separation of concerns:

```
lib/
├── core/                    # Dependency injection and utilities
├── data/                    # Data layer (repositories, data sources)
│   ├── datasources/         # Firebase implementations
│   └── repositories/        # Repository implementations
├── domain/                  # Business logic layer
│   ├── entities/            # Domain models
│   ├── repositories/        # Repository contracts
│   └── usecases/           # Business use cases
└── presentation/           # UI layer
    ├── bloc/               # BLoC state management
    ├── pages/              # Screen widgets
    └── widgets/            # Reusable UI components
```

## Features

- **Authentication**: Email/password sign-up and sign-in with Firebase Auth
- **CRUD Operations**: Create, read, update, and delete notes
- **Real-time Sync**: Notes are stored in Firestore and sync across devices
- **Clean Architecture**: Separation of concerns with dependency injection
- **State Management**: BLoC pattern for predictable state management
- **Error Handling**: Comprehensive error handling with user feedback
- **Responsive UI**: Material Design with proper feedback widgets

## State Management - BLoC Pattern

This app uses the BLoC (Business Logic Component) pattern for state management, which provides:

### Why BLoC?
- **Separation of Concerns**: Business logic is separated from UI components
- **Testability**: Easy to unit test business logic independently
- **Reusability**: BLoCs can be reused across different parts of the app
- **Predictable State**: Unidirectional data flow makes state changes predictable

### How BLoC Works:
1. **Events**: User interactions trigger events (e.g., `AddNoteRequested`)
2. **BLoC**: Processes events and emits new states
3. **States**: UI reacts to state changes (e.g., `NotesLoaded`, `NotesError`)

### Implementation Example:
```dart
// Event
context.read<NotesBloc>().add(AddNoteRequested(text: "My note", userId: userId));

// BLoC processes event and emits state
emit(NotesOperationSuccess("Note added successfully"));

// UI reacts to state
BlocListener<NotesBloc, NotesState>(
  listener: (context, state) {
    if (state is NotesOperationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
)
```

## Firebase Setup

### Prerequisites
1. Install Flutter SDK
2. Set up Firebase project at https://console.firebase.google.com
3. Enable Authentication (Email/Password) and Firestore Database

### Configuration Steps

1. **Android Setup**:
   - Download `google-services.json` from Firebase Console
   - Place it in `android/app/google-services.json`
   - The project is already configured with necessary gradle dependencies

2. **iOS Setup** (if needed):
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add it to `ios/Runner/` in Xcode

3. **Firestore Rules**:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /notes/{noteId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
       }
     }
   }
   ```

## Getting Started

1. **Clone the repository**
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Replace the placeholder `google-services.json` with your actual Firebase configuration
   - Update the project ID in the configuration files

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure Details

### Domain Layer
- **Entities**: Pure Dart classes representing business objects (Note, User)
- **Repositories**: Abstract contracts defining data operations
- **Use Cases**: Single-responsibility classes handling specific business logic

### Data Layer
- **DataSources**: Firebase implementations for authentication and Firestore operations
- **Repositories**: Concrete implementations of domain repository contracts

### Presentation Layer
- **BLoC**: State management handling user events and app state
- **Pages**: Complete screen widgets
- **Widgets**: Reusable UI components

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  
  # Firebase (compatible with Dart 2.15.1)
  firebase_core: ^1.24.0
  firebase_auth: ^3.11.2
  cloud_firestore: ^3.5.1
  
  # State Management
  flutter_bloc: ^8.1.1
  
  # Utils
  equatable: ^2.0.5
```

## CRUD Operations

The app implements all four CRUD operations:

1. **Create**: Add new notes via floating action button
2. **Read**: Fetch and display all user notes from Firestore
3. **Update**: Edit existing notes via edit icon
4. **Delete**: Remove notes with confirmation dialog

All operations provide user feedback through SnackBars and handle errors gracefully.

## Testing

To run the Dart analyzer and check for code quality:

```bash
flutter analyze
```

## Building for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Contributing

This project follows clean architecture principles. When adding new features:

1. Start with domain entities and use cases
2. Implement data sources and repositories
3. Create BLoC events and states
4. Build UI components

## License

This project is for educational purposes as part of ALU coursework.
