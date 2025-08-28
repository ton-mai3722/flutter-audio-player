# Audio Player App

A modern, feature-rich Flutter audio player application with an intuitive UI and comprehensive playback controls.

## Features

### Audio Player UI
- **Album Artwork Display**: Beautiful rounded album art with shadow effects
- **Song Information**: Track title, artist, and album display
- **Progress Bar**: Interactive seek bar with current and total duration
- **Playback Controls**: Play/pause, skip previous/next, shuffle, and repeat modes
- **Volume Control**: Adjustable volume slider
- **Additional Controls**: Queue, lyrics, equalizer, and share buttons

### Pages
1. **Now Playing**: Full-featured audio player interface
2. **Queue**: List of all available songs with artwork and details
3. **My Mixer**: Audio mixing controls (placeholder)
4. **Sleep Timer**: Timer functionality (placeholder)

### Navigation
- Bottom navigation bar for easy switching between pages
- Page view with smooth transitions
- Responsive design that works on different screen sizes

## Technical Features

### Audio Playback
- Uses `audioplayers` package for audio playback
- Support for network audio streaming
- Real-time position tracking
- Audio state management (playing, paused, loading)
- Error handling with fallback simulation

### UI Components
- Material Design principles
- Custom icons and buttons
- Smooth animations and transitions
- Responsive layout with scrollable content
- Purple color scheme

### Audio Controls
- **Play/Pause**: Toggle playback with loading indicator
- **Skip Controls**: Navigate to previous/next songs
- **Shuffle**: Randomize playback order
- **Repeat Modes**: Off, All, One
- **Volume Control**: 0-100% volume adjustment
- **Seek Bar**: Click to jump to specific position

## Sample Songs
The app comes with 5 sample songs:
1. Bohemian Rhapsody - Queen
2. Imagine - John Lennon
3. Hotel California - Eagles
4. Stairway to Heaven - Led Zeppelin
5. Billie Jean - Michael Jackson

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android/iOS device or emulator

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  audioplayers: ^6.1.0
```

## Project Structure
```
lib/
├── main.dart
└── features/
    └── now_playing/
        ├── data/
        │   └── audio_service.dart
        └── presentation/
            ├── pages/
            │   └── now_playing_main_page.dart
            └── widgets/
                ├── now_playing_control_page.dart
                └── queue_page.dart
```

## Usage

### Playing Audio
1. Launch the app
2. Navigate to the "Now Playing" tab
3. Tap the play button to start playback
4. Use skip buttons to change songs
5. Adjust volume using the volume slider

### Queue Management
1. Navigate to the "Queue" tab
2. View all available songs
3. Tap on any song to select it (shows snackbar)

### Audio Controls
- **Play/Pause**: Center button
- **Previous**: Left skip button
- **Next**: Right skip button
- **Shuffle**: Toggle shuffle mode
- **Repeat**: Cycle through repeat modes
- **Volume**: Use slider to adjust

## Customization

### Adding New Songs
Edit `audio_service.dart` and add new entries to the `sampleSongs` list:

```dart
{
  'id': 'unique_id',
  'title': 'Song Title',
  'artist': 'Artist Name',
  'album': 'Album Name',
  'duration': 'X:XX',
  'artwork': 'https://artwork_url',
  'url': 'https://audio_file_url',
}
```

### Theming
Modify the color scheme in the widget files to match your preferred theme.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
