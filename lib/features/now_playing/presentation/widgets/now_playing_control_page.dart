import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/audio_service.dart';

class NowPlayingControlPage extends StatefulWidget {
  const NowPlayingControlPage({super.key});

  @override
  State<NowPlayingControlPage> createState() => _NowPlayingControlPageState();
}

class _NowPlayingControlPageState extends State<NowPlayingControlPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _volume = 1.0;
  bool _isShuffleOn = false;
  RepeatMode _repeatMode = RepeatMode.off;

  // Current song data
  Map<String, dynamic> _currentSong = AudioService.getCurrentSong();

  @override
  void initState() {
    super.initState();
    log('====> NowPlayingControlPage initState');
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isLoading =
            state == PlayerState.playing && _currentPosition == Duration.zero;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    });
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        setState(() {
          _isLoading = true;
        });

        // Play the actual audio file
        await _audioPlayer.play(UrlSource(_currentSong['url']));
      } catch (e) {
        print('Error playing audio: $e');
        // Fallback to simulation if network audio fails
        setState(() {
          _isPlaying = true;
          _isLoading = true;
        });

        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _isLoading = false;
          _totalDuration = const Duration(minutes: 5, seconds: 55);
        });

        _simulateProgress();
      }
    }
  }

  void _playNextSong() {
    final nextSong = AudioService.getNextSong(_currentSong['id']);
    _changeSong(nextSong);
  }

  void _playPreviousSong() {
    final previousSong = AudioService.getPreviousSong(_currentSong['id']);
    _changeSong(previousSong);
  }

  void _changeSong(Map<String, dynamic> newSong) async {
    await _audioPlayer.stop();
    setState(() {
      _currentSong = newSong;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
      _isPlaying = false;
    });
  }

  void _simulateProgress() {
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isPlaying && _currentPosition < _totalDuration) {
          setState(() {
            _currentPosition = Duration(
              seconds: _currentPosition.inSeconds + 1,
            );
          });
          _simulateProgress();
        }
      });
    }
  }

  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _audioPlayer.seek(position);
    setState(() {
      _currentPosition = position;
    });
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffleOn = !_isShuffleOn;
    });
  }

  void _toggleRepeat() {
    setState(() {
      switch (_repeatMode) {
        case RepeatMode.off:
          _repeatMode = RepeatMode.all;
          break;
        case RepeatMode.all:
          _repeatMode = RepeatMode.one;
          break;
        case RepeatMode.one:
          _repeatMode = RepeatMode.off;
          break;
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildArtwork() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          _currentSong['artwork'],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.purple.shade300,
              child: const Icon(
                Icons.music_note,
                size: 80,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSongInfo() {
    return Column(
      children: [
        Text(
          _currentSong['title'],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _currentSong['artist'],
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _currentSong['album'],
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Slider(
          value: _totalDuration.inSeconds > 0
              ? _currentPosition.inSeconds.toDouble()
              : 0.0,
          max: _totalDuration.inSeconds.toDouble(),
          onChanged: _seekTo,
          activeColor: Colors.purple,
          inactiveColor: Colors.grey.shade300,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle button
        IconButton(
          onPressed: _toggleShuffle,
          icon: Icon(
            Icons.shuffle,
            color: _isShuffleOn ? Colors.purple : Colors.grey,
            size: 28,
          ),
        ),
        // Previous button
        IconButton(
          onPressed: _playPreviousSong,
          icon: const Icon(Icons.skip_previous, size: 36),
        ),
        // Play/Pause button
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.purple,
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _playPause,
            icon: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
          ),
        ),
        // Next button
        IconButton(
          onPressed: _playNextSong,
          icon: const Icon(Icons.skip_next, size: 36),
        ),
        // Repeat button
        IconButton(
          onPressed: _toggleRepeat,
          icon: Icon(
            _repeatMode == RepeatMode.one ? Icons.repeat_one : Icons.repeat,
            color: _repeatMode != RepeatMode.off ? Colors.purple : Colors.grey,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            // Implement playlist/queue functionality
          },
          icon: const Icon(Icons.queue_music),
        ),
        IconButton(
          onPressed: () {
            // Implement lyrics functionality
          },
          icon: const Icon(Icons.lyrics),
        ),
        IconButton(
          onPressed: () {
            // Implement equalizer functionality
          },
          icon: const Icon(Icons.equalizer),
        ),
        IconButton(
          onPressed: () {
            _showVolumePopup(context);
          },
          icon: Icon(
            _volume == 0 ? Icons.volume_off : Icons.volume_up,
            color: Colors.grey.shade600,
          ),
        ),
        IconButton(
          onPressed: () {
            // Implement share functionality
          },
          icon: const Icon(Icons.share),
        ),
      ],
    );
  }

  void _showVolumePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Volume Control',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Volume Icon and Percentage
                    Icon(
                      _volume == 0
                          ? Icons.volume_off
                          : _volume < 0.3
                          ? Icons.volume_down
                          : _volume < 0.7
                          ? Icons.volume_up
                          : Icons.volume_up,
                      size: 48,
                      color: Colors.purple,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      '${(_volume * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Volume Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.purple,
                        inactiveTrackColor: Colors.purple.withOpacity(0.2),
                        thumbColor: Colors.purple,
                        overlayColor: Colors.purple.withOpacity(0.2),
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24,
                        ),
                      ),
                      child: Slider(
                        value: _volume,
                        onChanged: (value) {
                          setModalState(() {
                            _volume = value;
                          });
                          setState(() {
                            _volume = value;
                          });
                          _audioPlayer.setVolume(value);
                        },
                        min: 0,
                        max: 1,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quick Volume Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildQuickVolumeButton(
                          icon: Icons.volume_mute,
                          label: 'Mute',
                          value: 0.0,
                          setModalState: setModalState,
                        ),
                        _buildQuickVolumeButton(
                          icon: Icons.volume_down,
                          label: '25%',
                          value: 0.25,
                          setModalState: setModalState,
                        ),
                        _buildQuickVolumeButton(
                          icon: Icons.volume_up,
                          label: '50%',
                          value: 0.5,
                          setModalState: setModalState,
                        ),
                        _buildQuickVolumeButton(
                          icon: Icons.volume_up,
                          label: '100%',
                          value: 1.0,
                          setModalState: setModalState,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickVolumeButton({
    required IconData icon,
    required String label,
    required double value,
    required StateSetter setModalState,
  }) {
    final isSelected = (_volume - value).abs() < 0.01;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _volume = value;
        });
        setState(() {
          _volume = value;
        });
        _audioPlayer.setVolume(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top spacing
              const SizedBox(height: 20),

              // Album artwork
              _buildArtwork(),

              const SizedBox(height: 40),

              // Song information
              _buildSongInfo(),

              const SizedBox(height: 30),

              // Progress bar
              _buildProgressBar(),

              const SizedBox(height: 20),

              // Control buttons
              _buildControlButtons(),

              const SizedBox(height: 20),

              // Additional controls
              _buildAdditionalControls(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

enum RepeatMode { off, all, one }
