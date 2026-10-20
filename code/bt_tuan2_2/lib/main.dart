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
      title: 'bt tuan 2 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StudentList(),
    );
  }
}

class Student {
  final String name;
  final String? email;
  final String? phone;

  Student({
    required this.name,
    this.email,
    this.phone,
  });
}

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Student> students = [
      Student(
        name: 'Nguyễn Văn An',
        email: 'an@sv.edu.vn',
        phone: '0901 234 567',
      ),
      Student(
        name: 'Trần Thị Bình',
        email: null,
        phone: '0912 888 999',
      ),
      Student(
        name: 'Lê Minh Chi',
        email: 'chi@sv.edu.vn',
        phone: null,
      ),
      Student(
        name: 'Phạm Quốc Dũng',
        email: null,
        phone: null,
      ),
      Student(
        name: 'Võ Thanh Em',
        email: 'em@sv.edu.vn',
        phone: '0933 111 222',
      ),
    ];

    int missingEmailCount = 0;
    for (var student in students) {
      if (student.email == null) {
        missingEmailCount++;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Danh sách sinh viên',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var student in students) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    // Hàng Email
                    Row(
                      children: [
                        const Text(
                          'Email: ',
                          style: TextStyle(fontSize: 13.0, color: Colors.black54),
                        ),
                        Text(
                          student.email ?? 'Chưa cập nhật',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: student.email == null
                                ? const Color(0xFFDC2626)
                                : Colors.black54,
                            fontStyle: student.email == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        const Text(
                          'SĐT: ',
                          style: TextStyle(fontSize: 13.0, color: Colors.black54),
                        ),
                        Text(
                          student.phone ?? 'Chưa cập nhật',
                          style: TextStyle(
                            fontSize: 13.0,
                            color: student.phone == null
                                ? const Color(0xFFDC2626)
                                : Colors.black54,
                            fontStyle: student.phone == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
            ],
            const SizedBox(height: 4.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng: ${students.length} sinh viên',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Thiếu email: ',
                        style: TextStyle(
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$missingEmailCount',
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}