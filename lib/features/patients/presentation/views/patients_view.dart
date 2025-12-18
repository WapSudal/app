import 'package:flutter/material.dart';

/// 환자 목록 화면 (보호자/주치의 전용)
///
/// 보호자나 주치의가 관리하는 환자 목록을 표시합니다.
/// TODO: 환자 목록 조회 및 관리 기능 구현 예정
class PatientsView extends StatelessWidget {
  const PatientsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 환자'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '환자 목록',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '환자 목록 기능은 추후 구현 예정입니다.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
