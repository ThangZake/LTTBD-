import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDHOJPk-bF1G_uwfmUXa3SjreSVDcdLxu0",
        authDomain: "uth-todo-1da3b.firebaseapp.com",
        projectId: "uth-todo-1da3b",
        storageBucket: "uth-todo-1da3b.firebasestorage.app",
        messagingSenderId: "538219089553",
        appId: "1:538219089553:web:b7caf0ff7d9d729167f930",
        measurementId: "G-VRXXS77HJJ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTH Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2B50EC)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class TodoItem {
  final String title;
  final String category;
  final String time;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.category,
    required this.time,
    this.isCompleted = false,
  });
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool _isGoogleInitialized = false;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    // 1. Chạy trên Web (Chrome): Dùng popup trực tiếp của Firebase Auth
    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      return await _auth.signInWithPopup(googleProvider);
    }

    // 2. Chạy trên Android: Chỉ khởi tạo GoogleSignIn một lần duy nhất
    if (!_isGoogleInitialized) {
      await GoogleSignIn.instance.initialize();
      _isGoogleInitialized = true;
    }

    final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
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
                      borderRadius: const BorderRadius.all(Radius.circular(2)),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (!mounted) return;

      if (userCredential != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!'), backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2B50EC);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.checklist_rtl_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 24),
              const Text(
                'Chào mừng đến với\nUTH Todo',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 12),
              Text(
                'Đăng nhập để lưu công việc và đồng bộ trên mọi thiết bị của bạn.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
              ),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  icon: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text(
                    'Tiếp tục với Google',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('hoặc', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text('Dùng thử không cần tài khoản', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Khi tiếp tục, bạn đồng ý với Điều khoản sử dụng và Chính sách quyền riêng tư của UTH Todo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  final List<TodoItem> _todos = [
    TodoItem(title: 'Tập thể dục 30 phút', category: 'Cuộc sống', time: '06:30', isCompleted: true),
    TodoItem(title: 'Nộp bài tập Lập trình di động', category: 'Học tập', time: '09:00', isCompleted: true),
    TodoItem(title: 'Ôn chương 3 - Cấu trúc dữ liệu', category: 'Học tập', time: '14:00'),
    TodoItem(title: 'Đi chợ mua đồ cho tuần', category: 'Cuộc sống', time: '17:30'),
  ];

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'MA';
  }

  void _openProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2B50EC);
    final String displayName = user?.displayName ?? 'Minh Anh';
    final int completedCount = _todos.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _openProfile,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFDBEAFE),
                      backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                      child: user?.photoURL == null
                          ? Text(_getInitials(displayName), style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold))
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _openProfile,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thứ Ba, 20 tháng 10', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          Text('Chào $displayName!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tiến độ hôm nay', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('$completedCount/${_todos.length} việc', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('Đã hơn nửa chặng, cố lên!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: completedCount / _todos.length,
                            strokeWidth: 6,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        Text('${((completedCount / _todos.length) * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildCategoryCard(Icons.school_outlined, 'Học tập', '2 việc còn lại', primaryBlue)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCategoryCard(Icons.wb_sunny_outlined, 'Cuộc sống', '2 việc còn lại', Colors.orange)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Việc hôm nay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Xem tất cả', style: TextStyle(fontSize: 13, color: primaryBlue, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              ..._todos.map((todo) => _buildTodoTile(todo, primaryBlue)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryBlue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) _openProfile();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Danh sách'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Thống kê'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Cá nhân'),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, String subtitle, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildTodoTile(TodoItem todo, Color activeColor) {
    final bool isStudy = todo.category == 'Học tập';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Checkbox(
            value: todo.isCompleted,
            activeColor: activeColor,
            shape: const CircleBorder(),
            onChanged: (val) => setState(() => todo.isCompleted = val ?? false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    color: todo.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isStudy ? const Color(0xFFDBEAFE) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        todo.category,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isStudy ? activeColor : Colors.orange.shade800),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(todo.time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'MA';
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2B50EC);
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'Minh Anh';
    final String email = user?.email ?? 'minhanh@example.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          label: const Text('Cài đặt'),
        ),
        title: const Text('Hồ sơ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: const Color(0xFFDBEAFE),
              backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? Text(_getInitials(displayName), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryBlue))
                  : null,
            ),
            const SizedBox(height: 12),
            Text(displayName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(email, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 14, color: Colors.green.shade700),
                  const SizedBox(width: 6),
                  Text('Đã liên kết tài khoản Google', style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(value: '2', label: 'Việc đã xong'),
                  _StatColumn(value: '4', label: 'Đang chờ'),
                  _StatColumn(value: '33%', label: 'Hoàn thành'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tuần này', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Việc xong mỗi ngày', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('T2', 36, true, primaryBlue),
                      _buildBar('T3', 24, true, primaryBlue),
                      _buildBar('T4', 8, false, primaryBlue),
                      _buildBar('T5', 8, false, primaryBlue),
                      _buildBar('T6', 8, false, primaryBlue),
                      _buildBar('T7', 8, false, primaryBlue),
                      _buildBar('CN', 8, false, primaryBlue),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text('Đăng xuất', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade100),
                  backgroundColor: Colors.red.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String day, double height, bool isActive, Color activeColor) {
    return Column(
      children: [
        Container(
          width: 18,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? activeColor : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
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