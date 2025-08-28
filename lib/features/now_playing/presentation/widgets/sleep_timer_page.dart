import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

class SleepTimerPage extends StatefulWidget {
  const SleepTimerPage({super.key});

  @override
  State<SleepTimerPage> createState() => _SleepTimerPageState();
}

class _SleepTimerPageState extends State<SleepTimerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double _selectedMinutes = 30.0;
  bool _isTimerRunning = false;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  String _selectedOption = '';

  final List<Map<String, dynamic>> _presetOptions = [
    {'label': '10 min', 'minutes': 10},
    {'label': '30 min', 'minutes': 30},
    {'label': '60 min', 'minutes': 60},
    {'label': '90 min', 'minutes': 90},
    {'label': 'End of audio', 'minutes': -1},
    {'label': 'End of playlist', 'minutes': -2},
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_selectedOption == 'End of audio' ||
        _selectedOption == 'End of playlist') {
      // Handle special cases
      setState(() {
        _isTimerRunning = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Timer set to $_selectedOption'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    _totalSeconds = (_selectedMinutes * 60).round();
    _remainingSeconds = _totalSeconds;

    setState(() {
      _isTimerRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
          _onTimerComplete();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = 0;
    });
  }

  void _onTimerComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sleep timer finished! Music stopped.'),
        backgroundColor: Colors.orange,
      ),
    );
    // Here you would implement stopping the music
  }

  void _selectPreset(Map<String, dynamic> option) {
    setState(() {
      _selectedOption = option['label'];
      if (option['minutes'] > 0) {
        _selectedMinutes = option['minutes'].toDouble();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (_totalSeconds == 0) return 0.0;
    return (_totalSeconds - _remainingSeconds) / _totalSeconds;
  }

  @override
  void initState() {
    log('====> SleepTimerPage initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                'Sleep Timer',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // Timer Display with Circular Progress
              _buildTimerDisplay(),

              const SizedBox(height: 40),

              // Time Slider
              if (!_isTimerRunning) _buildTimeSlider(),

              const SizedBox(height: 30),

              // Preset Options
              if (!_isTimerRunning) _buildPresetOptions(),

              const SizedBox(height: 40),

              // Start/Stop Button
              _buildControlButton(),

              const SizedBox(height: 20),

              // Selected Option Display
              if (_selectedOption.isNotEmpty) _buildSelectedOption(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),

          // Progress Circle
          if (_isTimerRunning)
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),

          // Sleep Icon and Time
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bedtime,
                size: 50,
                color: _isTimerRunning
                    ? Colors.deepPurple
                    : Colors.grey.shade600,
              ),
              const SizedBox(height: 12),
              Text(
                _isTimerRunning
                    ? _formatTime(_remainingSeconds)
                    : _formatTime((_selectedMinutes * 60).round()),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isTimerRunning
                      ? Colors.deepPurple
                      : Colors.grey.shade700,
                ),
              ),
              if (_isTimerRunning)
                Text(
                  'remaining',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlider() {
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
          const Text(
            'Select Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.deepPurple),
              const SizedBox(width: 12),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.deepPurple,
                    inactiveTrackColor: Colors.deepPurple.withOpacity(0.3),
                    thumbColor: Colors.deepPurple,
                    overlayColor: Colors.deepPurple.withOpacity(0.2),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                  ),
                  child: Slider(
                    value: _selectedMinutes,
                    onChanged: (value) {
                      setState(() {
                        _selectedMinutes = value;
                        _selectedOption = '${value.round()} min (Custom)';
                      });
                    },
                    min: 1,
                    max: 90,
                    divisions: 89,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '${_selectedMinutes.round()} min',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetOptions() {
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
          const Text(
            'Quick Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _presetOptions.map((option) {
              final isSelected = _selectedOption == option['label'];
              return GestureDetector(
                onTap: () => _selectPreset(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurple
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    option['label'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton() {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isTimerRunning ? _stopTimer : _startTimer,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isTimerRunning ? Colors.red : Colors.deepPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isTimerRunning ? Icons.stop : Icons.play_arrow, size: 28),
            const SizedBox(width: 12),
            Text(
              _isTimerRunning ? 'Stop Timer' : 'Start Timer',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedOption() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Selected: $_selectedOption',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
