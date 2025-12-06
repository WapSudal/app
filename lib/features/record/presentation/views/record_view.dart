import 'package:flutter/material.dart';

/// 기록 화면 (Placeholder)
///
/// TODO: Implement record functionality
class RecordView extends StatelessWidget {
  const RecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB), // dashboard/bg
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F6FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          '기록',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          '기록 화면\n(준비 중)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF989898),
          ),
        ),
      ),
    );
  }
}
