import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _contents = [
    OnboardingContent(
      title: 'Choose the type of Goods',
      description: 'Choose the type of waste ranging from clothes, toys etc',
      imagePath: 'assets/images/goods.png',
    ),
    OnboardingContent(
      title: 'Schedule a pick up',
      description: 'Right on your door step at your selected date and time',
      imagePath: 'assets/images/delivery_truck.png',
    ),
    OnboardingContent(
      title: 'Earn Green Coins',
      description: 'Earn green points on donation',
      imagePath: 'assets/images/green_coins.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundCircle(left: -100, bottom: -100, size: 200),
            _buildBackgroundCircle(right: -50, bottom: 50, size: 150),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _goToHome,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFFB5A9F8),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _contents.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) =>
                        OnboardingPage(content: _contents[index]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_contents.length, _buildDot),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _currentPage == _contents.length - 1
                      ? ElevatedButton(
                    onPressed: _goToHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B367C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: const Size.fromHeight(47),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  )
                      : const SizedBox(height: 47),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundCircle({
    double? left,
    double? right,
    required double bottom,
    required double size,
  }) {
    return Positioned(
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? const Color(0xFF6A5AE0)
            : const Color(0xFFD9D9D9),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;
  const OnboardingPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE6E1FF),
            ),
            child: Center(
              child: Image.asset(content.imagePath, width: 100, height: 100),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            content.title,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;
  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
