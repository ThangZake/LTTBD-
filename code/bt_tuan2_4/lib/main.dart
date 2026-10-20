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
      home: ScoreBoardScreen(),
    );
  }
}

class Student {
  String name;
  double? score;

  Student({
    required this.name,
    this.score
  });
}

class ScoreBoardScreen extends StatelessWidget {
  const ScoreBoardScreen({super.key});

  String getGrade(double? score) {
    if (score == null) return "Chưa có điểm";
    if (score >= 8.0) return "Giỏi";
    if (score >= 6.5) return "Khá";
    if (score >= 5.0) return "Trung bình";
    return "Yếu";
  }

  @override
  Widget build(BuildContext context) {
    List<Student> students = [
      Student(name: "Nguyễn Văn An", score: 9.0),
      Student(name: "Trần Thị Bình", score: 7.2),
      Student(name: "Lê Minh Chi", score: null),
      Student(name: "Phạm Quốc Dũng", score: 4.5),
      Student(name: "Võ Thanh Em", score: 5.8),
    ];

    double totalScore = 0;
    int gradedCount = 0;
    int goodCount = 0;
    int unratedCount = 0;
    double? maxScore;

    for (var student in students) {
      if (student.score != null) {
        double s = student.score!;
        totalScore += s;
        gradedCount++;
        if (s >= 8.0) {
          goodCount++;
        }
        if (maxScore == null || s > maxScore) {
          maxScore = s;
        }
      } else {
        unratedCount++;
      }
    }

    double avgScore = gradedCount > 0 ? (totalScore / gradedCount) : 0.0;

    List<Widget> studentWidgets = [];
    for (var student in students) {
      studentWidgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getGrade(student.score),
                    style: TextStyle(
                      fontSize: 12,
                      color: student.score == null
                          ? Colors.grey
                          : (student.score! >= 8.0
                          ? Colors.green
                          : (student.score! >= 6.5
                          ? Colors.blue
                          : (student.score! >= 5.0
                          ? Colors.orange
                          : Colors.red))),
                    ),
                  ),
                ],
              ),
              Text(
                student.score != null ? student.score!.toStringAsFixed(1) : "—",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: const Text(
          "Bảng điểm lớp",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF28406E),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF28406E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Điểm trung bình lớp",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    avgScore.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Giỏi",
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$goodCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chưa có điểm",
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$unratedCount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cao nhất",
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            maxScore != null ? maxScore.toStringAsFixed(1) : "—",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "DANH SÁCH • ${students.length} SINH VIÊN",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: studentWidgets,
            ),
          ),
        ],
      ),
    );
  }
}