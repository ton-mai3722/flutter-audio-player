class AudioService {
  static Map<String, dynamic>? _currentSong;

  static const List<Map<String, dynamic>> sampleSongs = [
    {
      'id': '1',
      'title': 'Bohemian Rhapsody',
      'artist': 'Queen',
      'album': 'A Night at the Opera',
      'duration': '5:55',
      'artwork': 'https://via.placeholder.com/300x300/9C27B0/FFFFFF?text=♪',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'id': '2',
      'title': 'Imagine',
      'artist': 'John Lennon',
      'album': 'Imagine',
      'duration': '3:01',
      'artwork': 'https://via.placeholder.com/300x300/2196F3/FFFFFF?text=♪',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'id': '3',
      'title': 'Hotel California',
      'artist': 'Eagles',
      'album': 'Hotel California',
      'duration': '6:30',
      'artwork': 'https://via.placeholder.com/300x300/FF9800/FFFFFF?text=♪',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
    {
      'id': '4',
      'title': 'Stairway to Heaven',
      'artist': 'Led Zeppelin',
      'album': 'Led Zeppelin IV',
      'duration': '8:02',
      'artwork': 'https://via.placeholder.com/300x300/4CAF50/FFFFFF?text=♪',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    },
    {
      'id': '5',
      'title': 'Billie Jean',
      'artist': 'Michael Jackson',
      'album': 'Thriller',
      'duration': '4:54',
      'artwork': 'https://via.placeholder.com/300x300/E91E63/FFFFFF?text=♪',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    },
  ];

  static Map<String, dynamic> getCurrentSong() {
    return _currentSong ?? sampleSongs.first;
  }

  static void setCurrentSong(Map<String, dynamic> song) {
    _currentSong = song;
  }

  static Map<String, dynamic> getNextSong(String currentId) {
    final currentIndex = sampleSongs.indexWhere(
      (song) => song['id'] == currentId,
    );
    if (currentIndex >= 0 && currentIndex < sampleSongs.length - 1) {
      return sampleSongs[currentIndex + 1];
    }
    return sampleSongs.first; // Loop back to first song
  }

  static Map<String, dynamic> getPreviousSong(String currentId) {
    final currentIndex = sampleSongs.indexWhere(
      (song) => song['id'] == currentId,
    );
    if (currentIndex > 0) {
      return sampleSongs[currentIndex - 1];
    }
    return sampleSongs.last; // Loop to last song
  }

  static List<Map<String, dynamic>> getAllSongs() {
    return sampleSongs;
  }
}
