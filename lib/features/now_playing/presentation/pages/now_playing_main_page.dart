import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/now_playing_control_page.dart';
import '../widgets/queue_page.dart';
import '../widgets/my_mixer_page.dart';
import '../widgets/sleep_timer_page.dart';

class NowPlayingMainPage extends StatefulWidget {
  const NowPlayingMainPage({super.key});

  @override
  State<NowPlayingMainPage> createState() => _NowPlayingMainPageState();
}

class _NowPlayingMainPageState extends State<NowPlayingMainPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> _pages = [
    "Now Playing",
    "Queue",
    "My Mixer",
    "Sleep Timer",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pages[_currentIndex])),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 100,
        ), // Add padding for floating nav
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: const [
            NowPlayingControlPage(),
            QueuePage(),
            MyMixerPage(),
            SleepTimerPage(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(Icons.play_circle, 0),
              const SizedBox(width: 20),
              _buildNavItem(Icons.queue_music, 1),
              const SizedBox(width: 20),
              _buildNavItem(Icons.equalizer, 2),
              const SizedBox(width: 20),
              _buildNavItem(Icons.nightlight, 3),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey.shade600,
          size: 24,
        ),
      ),
    );
  }
}
