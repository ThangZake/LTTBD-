import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ResetPasswordData {
  final String email;
  final String otp;
  final String password;

  ResetPasswordData({
    required this.email,
    required this.otp,
    required this.password,
  });
}

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
      home: const screenDemoTuan4_2(title: 'Flutter Demo Home Page'),
    );
  }
}

class UthHeader extends StatelessWidget {
  final bool showBackButton;

  const UthHeader({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: showBackButton
              ? InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF29B6F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          )
              : const SizedBox(height: 38),
        ),
        const SizedBox(height: 12),
        const Text(
          'UTH',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Color(0xFF00796B),
            letterSpacing: 1.5,
            height: 1.0,
          ),
        ),
        const Text(
          'UNIVERSITY\nOF TRANSPORT\nHOCHIMINH CITY',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD32F2F),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'SmartTasks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }
}

Widget buildPrimaryButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

InputDecoration buildInputDecoration({
  required String hintText,
  required IconData prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 20),
    filled: true,
    fillColor: const Color(0xFFF8F9FA),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2196F3)),
    ),
  );
}

class screenDemoTuan4_2 extends StatefulWidget {
  const screenDemoTuan4_2({super.key, required this.title});
  final String title;

  @override
  State<screenDemoTuan4_2> createState() => _screenDemoTuan4_2State();
}

class _screenDemoTuan4_2State extends State<screenDemoTuan4_2> {
  final TextEditingController _emailController = TextEditingController();
  ResetPasswordData? _submittedData;

  Future<void> _goToVerification() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Email của bạn')),
      );
      return;
    }

    final result = await Navigator.push<ResetPasswordData>(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationScreen(email: email),
      ),
    );

    if (result != null) {
      setState(() {
        _submittedData = result;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const UthHeader(showBackButton: false),
              const SizedBox(height: 28),
              const Text(
                'Forget Password?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your Email, we will send you a verification\ncode.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: buildInputDecoration(
                  hintText: 'Your Email',
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 24),
              buildPrimaryButton(
                text: 'Next',
                onPressed: _goToVerification,
              ),
              const SizedBox(height: 36),
              if (_submittedData != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Email: ${_submittedData!.email}',
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'OTP: ${_submittedData!.otp}',
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pass: ${_submittedData!.password}',
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final int _otpLength = 5;
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _goToResetPassword() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ mã xác thực')),
      );
      return;
    }

    final result = await Navigator.push<ResetPasswordData>(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(
          email: widget.email,
          otp: otp,
        ),
      ),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const UthHeader(showBackButton: true),
              const SizedBox(height: 28),
              const Text(
                'Verify Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the the code\nwe just sent you on your registered Email',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_otpLength, (index) {
                  return SizedBox(
                    width: 54,
                    height: 54,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFFF2F2F5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2196F3),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < _otpLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              buildPrimaryButton(
                text: 'Next',
                onPressed: _goToResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _goToConfirm() async {
    final pass = _passController.text;
    final confirmPass = _confirmPassController.text;

    if (pass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ mật khẩu')),
      );
      return;
    }

    if (pass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    final result = await Navigator.push<ResetPasswordData>(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmScreen(
          data: ResetPasswordData(
            email: widget.email,
            otp: widget.otp,
            password: pass,
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const UthHeader(showBackButton: true),
              const SizedBox(height: 28),
              const Text(
                'Create new password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your new password must be different form\npreviously used password',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: buildInputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: buildInputDecoration(
                  hintText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 28),
              buildPrimaryButton(
                text: 'Next',
                onPressed: _goToConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmScreen extends StatelessWidget {
  final ResetPasswordData data;

  const ConfirmScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const UthHeader(showBackButton: true),
              const SizedBox(height: 28),
              const Text(
                'Confirm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'We are here to help you!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController(text: data.email),
                readOnly: true,
                decoration: buildInputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: data.otp),
                readOnly: true,
                decoration: buildInputDecoration(
                  hintText: 'OTP',
                  prefixIcon: Icons.mail_outline,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: data.password),
                readOnly: true,
                obscureText: true,
                decoration: buildInputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                ),
              ),
              const SizedBox(height: 28),
              buildPrimaryButton(
                text: 'Summit',
                onPressed: () {
                  Navigator.pop(context, data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}