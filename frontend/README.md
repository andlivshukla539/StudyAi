# StudyAi - Mobile & Web Frontend

Modern cross-platform mobile and web application built with Flutter, Riverpod state management, and Material 3 design system.

## 📱 Features

- **Personalized Dashboard**: Track study streaks, today's targets, and daily AI study tips.
- **AI Tutor Chat**: Interactive conversation with Gemini AI, featuring LaTeX formula and markdown formatting.
- **Document Hub & PDF Reader**: Upload and view PDFs directly in-app with `syncfusion_flutter_pdfviewer`.
- **Quiz Arena**: Interactive MCQ quizzes generated from your materials with instant score calculation.
- **Study Planner & Focus Timer**: Integrated Pomodoro timer and schedule tracking.
- **Flashcard Deck**: Spaced repetition flashcards to reinforce retention.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.2.0 <4.0.0`
- Dart SDK `>=3.2.0`
- Android Studio / Xcode for mobile emulation or physical device debugging

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Code Generation (Freezed / JSON Serialization)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Configure API Endpoint
In `lib/core/network/dio_client.dart`, verify or update `baseUrl` to point to your backend:
- Android Emulator: `http://10.0.2.2:3000/api/v1`
- iOS Simulator: `http://localhost:3000/api/v1`
- Physical Device: `http://<your-lan-ip>:3000/api/v1` or tunnel URL

### 4. Run Application
```bash
# Debug mode
flutter run

# Web preview
flutter run -d chrome
```

## 📂 Architecture Overview

```text
lib/
├── core/
│   ├── components/    # Reusable UI widgets (cards, buttons, chips, loaders)
│   ├── network/       # Dio HTTP client, auth interceptor & error handlers
│   ├── routing/       # GoRouter routes and route guards
│   └── theme/         # App colors, typography, spacing & theme definition
├── features/
│   ├── auth/          # Login, Register, Splash & Auth provider
│   ├── chat/          # AI Tutor chat interface
│   ├── dashboard/     # Home screen & study metrics
│   ├── documents/     # PDF viewer & document management
│   ├── focus_timer/   # Pomodoro focus session timer
│   ├── flashcard/     # Flashcard review screen
│   ├── profile/       # User profile & settings
│   ├── quiz/          # Quiz setup, question flow & results
│   └── study_plan/    # AI study schedule view
└── main.dart          # Application bootstrap
```
