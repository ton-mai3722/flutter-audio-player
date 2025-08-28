import 'dart:developer';

import 'package:flutter/material.dart';

class MyMixerPage extends StatefulWidget {
  const MyMixerPage({super.key});

  @override
  State<MyMixerPage> createState() => _MyMixerPageState();
}

class _MyMixerPageState extends State<MyMixerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Main Audio controls
  bool _mainAudioMuted = false;
  double _mainAudioVolume = 0.7;
  final String _mainAudioName = "Main Audio";

  // BGM controls
  bool _bgmMuted = false;
  double _bgmVolume = 0.5;
  final String _bgmName = "Background Music";

  // Ambient controls
  bool _ambientMuted = false;
  double _ambientVolume = 0.3;
  final String _ambientName = "Ambient Sound";

  @override
  void initState() {
    log('====> MyMixerPage initState');
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                'Audio Mixer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // Section 1: Main Audio
              _buildAudioSection(
                title: "Section 1: Main Audio",
                displayName: _mainAudioName,
                isMuted: _mainAudioMuted,
                volume: _mainAudioVolume,
                onMuteToggle: () {
                  setState(() {
                    _mainAudioMuted = !_mainAudioMuted;
                  });
                },
                onVolumeChanged: (value) {
                  setState(() {
                    _mainAudioVolume = value;
                  });
                },
                iconData: Icons.music_note,
                color: Colors.purple,
              ),

              const SizedBox(height: 30),

              // Section 2: BGM
              _buildAudioSection(
                title: "Section 2: Background Music",
                displayName: _bgmName,
                isMuted: _bgmMuted,
                volume: _bgmVolume,
                onMuteToggle: () {
                  setState(() {
                    _bgmMuted = !_bgmMuted;
                  });
                },
                onVolumeChanged: (value) {
                  setState(() {
                    _bgmVolume = value;
                  });
                },
                iconData: Icons.library_music,
                color: Colors.blue,
              ),

              const SizedBox(height: 30),

              // Section 3: Ambient
              _buildAudioSection(
                title: "Section 3: Ambient Sound",
                displayName: _ambientName,
                isMuted: _ambientMuted,
                volume: _ambientVolume,
                onMuteToggle: () {
                  setState(() {
                    _ambientMuted = !_ambientMuted;
                  });
                },
                onVolumeChanged: (value) {
                  setState(() {
                    _ambientVolume = value;
                  });
                },
                iconData: Icons.nature,
                color: Colors.green,
              ),

              const SizedBox(height: 40),

              // Master Controls
              _buildMasterControls(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioSection({
    required String title,
    required String displayName,
    required bool isMuted,
    required double volume,
    required VoidCallback onMuteToggle,
    required ValueChanged<double> onVolumeChanged,
    required IconData iconData,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          // Display Name and Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      isMuted ? 'Muted' : 'Playing',
                      style: TextStyle(
                        fontSize: 14,
                        color: isMuted ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Mute/Unmute Button
              GestureDetector(
                onTap: onMuteToggle,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMuted
                        ? Colors.red.withOpacity(0.1)
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up,
                    color: isMuted ? Colors.red : color,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Volume Control
          Row(
            children: [
              Icon(Icons.volume_down, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: color,
                    inactiveTrackColor: color.withOpacity(0.3),
                    thumbColor: color,
                    overlayColor: color.withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: isMuted ? 0 : volume,
                    onChanged: isMuted ? null : onVolumeChanged,
                    min: 0,
                    max: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.volume_up, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Container(
                width: 40,
                alignment: Alignment.centerRight,
                child: Text(
                  '${(volume * 100).round()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasterControls() {
    final masterVolume = (_mainAudioVolume + _bgmVolume + _ambientVolume) / 3;
    final allMuted = _mainAudioMuted && _bgmMuted && _ambientMuted;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Master Controls',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // Mute All Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      final newMuteState = !allMuted;
                      _mainAudioMuted = newMuteState;
                      _bgmMuted = newMuteState;
                      _ambientMuted = newMuteState;
                    });
                  },
                  icon: Icon(
                    allMuted ? Icons.volume_off : Icons.volume_up,
                    size: 20,
                  ),
                  label: Text(allMuted ? 'Unmute All' : 'Mute All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allMuted ? Colors.red : Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Reset Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _mainAudioVolume = 0.7;
                      _bgmVolume = 0.5;
                      _ambientVolume = 0.3;
                      _mainAudioMuted = false;
                      _bgmMuted = false;
                      _ambientMuted = false;
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Master Volume Display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Master Volume',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple,
                  ),
                ),
                Text(
                  '${(masterVolume * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
