import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GradeClassificationScreen(),
    );
  }
}

class GradeClassificationScreen extends StatelessWidget {
  const GradeClassificationScreen({super.key});

  String xepLoai(double diem) {
    if (diem < 0 || diem > 10) {
      return 'Không hợp lệ';
    } else if (diem >= 8.0) {
      return 'Giỏi';
    } else if (diem >= 6.5) {
      return 'Khá';
    } else if (diem >= 5.0) {
      return 'Trung bình';
    } else {
      return 'Yếu';
    }
  }

  Color layMauXepLoai(String loai) {
    if (loai == 'Giỏi') {
      return const Color(0xFF2E7D32); // Xanh lá
    } else if (loai == 'Khá') {
      return const Color(0xFF1976D2); // Xanh dương
    } else if (loai == 'Trung bình') {
      return const Color(0xFFED6C02); // Cam / vàng cam
    } else if (loai == 'Yếu') {
      return const Color(0xFFD32F2F); // Đỏ
    } else {
      return const Color(0xFF757575); // Xám (cho Không hợp lệ)
    }
  }

  Widget _buildCheckRow(double diem) {
    final loai = xepLoai(diem);
    final mauChu = layMauXepLoai(loai);
    final diemHienThi = diem % 1 == 0 ? diem.toInt().toString() : diem.toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Điểm $diemHienThi',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: mauChu.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              loai,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: mauChu,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double diem = 8.5;
    final String ketQuaXepLoai = xepLoai(diem);
    final Color mauChinh = layMauXepLoai(ketQuaXepLoai);
    const List<double> diemKiemTraThem = [9, 7, 5.5, 3, 11];
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: const Text(
          'Xếp loại học lực',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2A5298),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Điểm trung bình',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diem.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: mauChinh.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        ketQuaXepLoai,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mauChinh,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'KIỂM TRA THÊM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF666666),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: diemKiemTraThem
                      .map((diemTest) => _buildCheckRow(diemTest))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}