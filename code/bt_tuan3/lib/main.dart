import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UI Components',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/list': (context) => const ComponentListScreen(),
        '/detail_text': (context) => const TextDetailScreen(),
        '/detail_image': (context) => const ImageDetailScreen(),
        '/detail_textfield': (context) => const TextFieldDetailScreen(),
        '/detail_row': (context) => const RowLayoutDetailScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.widgets_rounded,
                  size: 60,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Jetpack Compose',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Jetpack Compose is a modern UI toolkit for building native Android applications using a declarative programming approach.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/list');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    "I'm ready",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComponentListScreen extends StatelessWidget {
  const ComponentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UI Components List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2979FF),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          const Text(
            'Display',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildItem(
            title: 'Text',
            subtitle: 'Displays text',
            color: const Color(0xFFD6E4FF),
            textColor: Colors.black87,
            onTap: () => Navigator.pushNamed(context, '/detail_text'),
          ),
          const SizedBox(height: 10),
          _buildItem(
            title: 'Image',
            subtitle: 'Displays an image',
            color: const Color(0xFFD6E4FF),
            textColor: Colors.black87,
            onTap: () => Navigator.pushNamed(context, '/detail_image'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Input',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildItem(
            title: 'TextField',
            subtitle: 'Input field for text',
            color: const Color(0xFFD6E4FF),
            textColor: Colors.black87,
            onTap: () => Navigator.pushNamed(context, '/detail_textfield'),
          ),
          const SizedBox(height: 10),
          _buildItem(
            title: 'PasswordField',
            subtitle: 'Input field for passwords',
            color: const Color(0xFFD6E4FF),
            textColor: Colors.black87,
            onTap: () => Navigator.pushNamed(context, '/detail_textfield'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Layout',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildItem(
            title: 'Column',
            subtitle: 'Arranges elements vertically',
            color: const Color(0xFFD6E4FF),
            textColor: Colors.black87,
            onTap: () => Navigator.pushNamed(context, '/detail_row'),
          ),
          const SizedBox(height: 10),
          _buildItem(
            title: 'Row',
            subtitle: 'Arranges elements horizontally',
            color: const Color(0xFFD6E4FF),
            textColor: Colors.black87,
            onTap: () => Navigator.pushNamed(context, '/detail_row'),
          ),
          const SizedBox(height: 10),
          _buildItem(
            title: 'Tự tìm hiểu',
            subtitle: 'Tìm ra tất cả các thành phần UI Cơ bản',
            color: const Color(0xFFFFCDD2),
            textColor: const Color(0xFFC62828),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextDetailScreen extends StatelessWidget {
  const TextDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2979FF), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Text Detail',
          style: TextStyle(
            color: Color(0xFF2979FF),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 26, color: Colors.black, height: 1.5),
              children: [
                TextSpan(text: 'The '),
                TextSpan(
                  text: 'quick ',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                TextSpan(
                  text: 'Brown\n',
                  style: TextStyle(
                    color: Color(0xFFB06F23),
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                TextSpan(
                  text: 'fox ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text: 'j u m p s ',
                  style: TextStyle(letterSpacing: 2),
                ),
                TextSpan(
                  text: 'over\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: 'the ',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(
                  text: 'lazy ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: 'dog.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2979FF), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Images',
          style: TextStyle(
            color: Color(0xFF2979FF),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://picsum.photos/600/350',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'https://picsum.photos/600/350',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.blueGrey.shade100,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_city, size: 60, color: Colors.blueGrey),
                    SizedBox(height: 8),
                    Text(
                      'Local / In app asset',
                      style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'In app',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldDetailScreen extends StatefulWidget {
  const TextFieldDetailScreen({super.key});

  @override
  State<TextFieldDetailScreen> createState() => _TextFieldDetailScreenState();
}

class _TextFieldDetailScreenState extends State<TextFieldDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  String _currentText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2979FF), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TextField',
          style: TextStyle(
            color: Color(0xFF2979FF),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _currentText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Thông tin nhập',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFF2979FF)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _currentText.isEmpty ? 'Tự động cập nhật dữ liệu theo textfield' : _currentText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RowLayoutDetailScreen extends StatelessWidget {
  const RowLayoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2979FF), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Row Layout',
          style: TextStyle(
            color: Color(0xFF2979FF),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF90CAF9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF90CAF9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}