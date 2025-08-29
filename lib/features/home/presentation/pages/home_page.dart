import 'package:flutter/material.dart';
import '../../../now_playing/data/audio_service.dart';
import '../../../now_playing/presentation/pages/now_playing_main_page.dart';
import '../widgets/audio_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _songs = AudioService.getAllSongs();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSongs = _songs.where((song) {
      return song['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song['artist'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song['album'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),

            // Search Bar
            _buildSearchBar(),

            // Music List
            Expanded(child: _buildMusicList(filteredSongs)),
          ],
        ),
      ),
      // Play All Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_songs.isNotEmpty) {
            _playAllSongs();
          }
        },
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text(
          'Play All',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good ${_getTimeOfDay()}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Music Library',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              // Profile/Settings Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.grey.shade700,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              _buildStatItem('${_songs.length}', 'Songs'),
              const SizedBox(width: 20),
              _buildStatItem('1', 'Playlist'),
              const SizedBox(width: 20),
              _buildStatItem('${_getEstimatedDuration()}', 'Duration'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey.shade500),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMusicList(List<Map<String, dynamic>> songs) {
    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No songs found'
                  : 'No results for "$_searchQuery"',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                child: const Text('Clear search'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return AudioListItem(
          song: song,
          onTap: () => _navigateToNowPlaying(song),
          onMoreTap: () => _showSongOptions(song),
        );
      },
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  String _getEstimatedDuration() {
    // Estimate 4 minutes per song
    final totalMinutes = _songs.length * 4;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  void _navigateToNowPlaying(Map<String, dynamic> selectedSong) {
    // Update the current song in AudioService
    AudioService.setCurrentSong(selectedSong);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NowPlayingMainPage()),
    );
  }

  void _playAllSongs() {
    if (_songs.isNotEmpty) {
      // Set the first song as current
      AudioService.setCurrentSong(_songs[0]);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NowPlayingMainPage()),
      );
    }
  }

  void _showSongOptions(Map<String, dynamic> song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Song info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song['artwork'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          color: Colors.purple.shade100,
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.purple,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          song['artist'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Options
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play Now'),
              onTap: () {
                Navigator.pop(context);
                _navigateToNowPlaying(song);
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: const Text('Add to Queue'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add to queue
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement add to favorites
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement share
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
