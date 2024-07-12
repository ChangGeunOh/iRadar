import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  static String get routeName => 'app-info';

  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'App 정보',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/images/img_mobile.jpg'),
            const SizedBox(height: 48),
            const Text(
              "iRadar 2.0",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '현재 버전 : 1.0.0',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            const Text(
              'iRadar는 Flutter와 fast-api로 제작되었습니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ));
  }
}
