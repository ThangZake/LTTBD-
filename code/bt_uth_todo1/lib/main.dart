import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B50EC),
      body: SafeArea(
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UthLogoWidget(isLarge: true),
                  SizedBox(height: 20),
                  Text(
                    'UTH Todo',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Việc học, việc nhà – gọn gàng mỗi ngày',
                    style: TextStyle(color: Color(0xD9FFFFFF), fontSize: 13),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: 90,
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: const LinearProgressIndicator(
                        value: 0.45,
                        backgroundColor: Color(0x4DFFFFFF),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Phiên bản 2.1.0', style: TextStyle(color: Color(0xBFFFFFFF), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    {
      'title': 'Mọi việc, gọn trong một\nchỗ',
      'desc': 'Ghi lại bài tập, việc nhà, lịch hẹn. Không\ncòn quên việc nào.',
      'button': 'Tiếp tục',
    },
    {
      'title': 'Chia theo Học tập và\nCuộc sống',
      'desc': 'Mỗi việc có nhóm riêng, nhìn là biết hôm\nnay cần lo gì.',
      'button': 'Tiếp tục',
    },
    {
      'title': 'Nhắc đúng lúc',
      'desc': 'Bật thông báo để UTH Todo nhắc bạn\ntrước hạn chót.',
      'button': 'Bắt đầu ngay',
    },
  ];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chuyển vào màn hình chính!')),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2B50EC);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const UthLogoWidget(isLarge: false),
                      const SizedBox(width: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(text: 'UTH ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Todo', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text('Bỏ qua', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(flex: 2),
                      Center(child: _buildIllustration(i)),
                      const Spacer(flex: 2),
                      Text(
                        _pages[i]['title']!,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _pages[i]['desc']!,
                        style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600, height: 1.45),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(3, (i) {
                  final active = _currentPage == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    height: 6,
                    width: active ? 18 : 6,
                    decoration: BoxDecoration(
                      color: active ? primaryBlue : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _pages[_currentPage]['button']!,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(int index) {
    return Container(
      width: 210,
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(24)),
      child: index == 0
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _todoItem(true),
          const SizedBox(height: 12),
          _todoItem(false),
          const SizedBox(height: 12),
          _todoItem(false),
        ],
      )
          : index == 1
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _catCard('Học tập', const Color(0xFFDCE6FF), const Color(0xFF2B50EC)),
          const SizedBox(height: 14),
          _catCard('Cuộc sống', const Color(0xFFFFEBD6), const Color(0xFFB86B11)),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF2B50EC), size: 32),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Text(
              'Ôn bài Toán lúc 19:00',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _todoItem(bool checked) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: checked ? const Color(0xFF2B50EC) : Colors.transparent,
              border: checked ? null : Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
            child: checked ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Container(
            width: 85,
            height: 6,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
          ),
        ],
      ),
    );
  }

  Widget _catCard(String label, Color bg, Color fg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Container(
            width: 100,
            height: 6,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
          ),
        ],
      ),
    );
  }
}

class UthLogoWidget extends StatelessWidget {
  final bool isLarge;
  const UthLogoWidget({super.key, required this.isLarge});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2B50EC);
    final bgColor = isLarge ? Colors.white : primaryBlue;
    final activeColor = isLarge ? primaryBlue : Colors.white;
    final inactiveColor = isLarge ? Colors.grey.shade400 : const Color(0x99FFFFFF);

    return Container(
      width: isLarge ? 84.0 : 28.0,
      height: isLarge ? 84.0 : 28.0,
      padding: EdgeInsets.all(isLarge ? 18.0 : 6.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(isLarge ? 22.0 : 7.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Container(
                width: isLarge ? 15.0 : 5.0,
                height: isLarge ? 15.0 : 5.0,
                decoration: BoxDecoration(color: activeColor, shape: BoxShape.circle),
                child: Icon(Icons.check, size: isLarge ? 10.0 : 3.5, color: bgColor),
              ),
              SizedBox(width: isLarge ? 7.0 : 2.5),
              Expanded(
                child: Container(
                  height: isLarge ? 7.0 : 2.5,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(isLarge ? 3.5 : 1.5),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: isLarge ? 15.0 : 5.0,
                height: isLarge ? 15.0 : 5.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: inactiveColor, width: isLarge ? 2.0 : 1.0),
                ),
              ),
              SizedBox(width: isLarge ? 7.0 : 2.5),
              Expanded(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.75,
                  child: Container(
                    height: isLarge ? 7.0 : 2.5,
                    decoration: BoxDecoration(
                      color: inactiveColor,
                      borderRadius: BorderRadius.circular(isLarge ? 3.5 : 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}