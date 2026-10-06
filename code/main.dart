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
      home: const manHinhGioiThieu(),
    );
  }
}

class manHinhGioiThieu extends StatelessWidget{
  const manHinhGioiThieu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          const SizedBox(height: 300,),
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/avatar.png'),
          ),
          const Text("Trần Tiến Thắng",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              )
            ),
          const Text("080206008259",
            style: TextStyle(
              fontSize: 25,
              ),
            ),
          ],
        )
      ),
    );
  }
}