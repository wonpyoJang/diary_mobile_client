# Diary Mobile Client

Diary Mobile Client is a Flutter application for logging daily "moments" and visualizing emotions. The project demonstrates a modular Flutter architecture built around the BLoC state management pattern, dependency injection and integration with generative AI services.

## Features

- **Write Diary Moments**: Create entries with text reflections and track the time they were written.
- **Emotion Analysis**: Uses a generative AI service to extract emotions from your writing and display them with intensity values.
- **Calendar & List Views**: Browse past moments in either a calendar interface or a chronological list.
- **Shareable Screenshots**: Capture emotion palettes as images to share on social media or save locally.
- **Theme & Mode Settings**: Toggle calendar mode, switch between light/dark/system themes and other preferences.
- **Cross‑Platform**: Runs on Android, iOS, Web, macOS, Windows and Linux via Flutter.

## Collaboration (GitHub)

Role-based issues and labels (engineering, business, growth, product) are described in [`.github/COMMUNICATION.md`](.github/COMMUNICATION.md).

## Project Structure

The `lib` directory follows a layered approach:

```
lib/src
├── app.dart                    # App entry widgets
├── bus/                        # Simple message bus implementation
├── core/                       # Analytics, HTTP, Firebase, LLM utilities
├── feature/                    # Feature modules (moment, settings, splash, …)
├── injection.dart              # GetIt/Injectable setup
└── injection.config.dart       # Generated dependency configuration
```

Moment features are divided into `application`, `domain`, `infrastructure` and `presentation` layers. State is managed using `flutter_bloc`/`hydrated_bloc` and dependencies are injected with `get_it` & `injectable`.

## Getting Started

1. [Install Flutter](https://docs.flutter.dev/get-started/install) (version `3.5.4` or later).
2. Clone this repository.
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on a connected device or emulator:
   ```bash
   flutter run
   ```

### Running Tests

Widget tests can be executed with:

```bash
flutter test
```

(Only a smoke test is currently included.)

## Build Management with Makefile

This project includes a comprehensive Makefile for managing generated files and build artifacts across all platforms.

### Available Commands

#### **Basic Cleanup Commands**
- `make clean` - Remove Flutter generated files only
- `make clean-all` - Remove all generated files and build caches

#### **Full Regeneration**
- `make regenerate` - Regenerate all generated files for all platforms

#### **Platform-Specific Regeneration**
- `make regenerate-ios` - iOS only regeneration
- `make regenerate-android` - Android only regeneration  
- `make regenerate-macos` - macOS only regeneration
- `make regenerate-linux` - Linux only regeneration
- `make regenerate-windows` - Windows only regeneration
- `make regenerate-web` - Web only regeneration

#### **Help**
- `make help` - Display available commands

### Usage Examples

```bash
# Regenerate all generated files for all platforms
make regenerate

# Regenerate only for specific platform (e.g., iOS)
make regenerate-ios

# Clean generated files only
make clean

# Show help
make help
```

### What Gets Cleaned/Regenerated

The Makefile manages:
- **Flutter Generated Files**: `*.g.dart` files, plugin registrants
- **Build Caches**: `build/`, `.dart_tool/`, `.flutter-plugins*`
- **Platform Dependencies**: `ios/Pods/`, `macos/Pods/`, `android/.gradle/`
- **Platform Builds**: All platform-specific build outputs

## Assets

Custom fonts and images are located under `assets/`. Application icons and splash screens are configured via `flutter_launcher_icons` and `flutter_native_splash`.

## Contributing

Feel free to fork the project and submit pull requests. Issues and feature requests are also welcome!

## Contributors

- 공서진 - 기획자 & 디자이너
- 장원표 - 개발자

