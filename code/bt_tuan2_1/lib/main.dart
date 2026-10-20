import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bt tuan 2',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Screen03(),
    );
  }
}

class Screen03 extends StatefulWidget{
  const Screen03 ({super.key});
  @override
  State<Screen03> createState() => _Screen03State();
}

class _Screen03State extends State<Screen03>{
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  String? _selectedOp;
  String? _result;

  void _caculate( String op ){
    setState(() {
      _selectedOp = op;
      final double? n1 = double.tryParse(_num1Controller.text);
      final double? n2 = double.tryParse(_num2Controller.text);
      if ( n1 == null || n2 == null ){
        _result = 'Vui lòng nhập 2 số hợp lệ';
        return;
      }

      double res = 0;
      switch(op){
        case '+':
          res = n1 + n2;
        break;
        case '-':
          res = n1 - n2;
          break;
        case '*':
          res = n1 * n2;
          break;
        case '/':
          if(n2 == 0){
            _result = "Mẫu không thể là 0";
            return;
          }
          res = n1 / n2;
          break;
      }

      _result = (res % 1 == 0)?
      res.toInt().toString() : res.toStringAsFixed(2);
    });
  }

  @override
  void dispose(){
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }

  Widget _buildOpButton({ required String op, required Color color,}){
    final bool isSelected = _selectedOp == op;
    return GestureDetector(
      onTap: () => _caculate(op),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: isSelected?
              Border.all(color: Colors.black, width: 2.5):
              Border.all(color: Colors.transparent, width: 2.5),
        ),
        alignment: Alignment.center,
        child: Text(
          op,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text('Thực hành 03',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: _num1Controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (_){
                    if (_selectedOp != null) _caculate(_selectedOp!);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOpButton(op: '+', color: const Color(0xFFD9534F)),
                    _buildOpButton(op: '-', color: const Color(0xFFEAA64E)),
                    _buildOpButton(op: '*', color: const Color(0xFF5B50D6)),
                    _buildOpButton(op: '/', color: const Color(0xFF2B2D2F)),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _num2Controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (_) {
                    if (_selectedOp != null) _caculate(_selectedOp!);
                  },
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kết quả:$_result',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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

