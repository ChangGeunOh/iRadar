import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UnsplashCopyright extends StatelessWidget {
  const UnsplashCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '사진: ',
        children: [
          TextSpan(
            text: 'Unsplash',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://unsplash.com/@heftiba?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText');
              },
          ),
          const TextSpan(text: '의 '),
          TextSpan(
            text: 'Toa Heftiba',
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(
                    'https://unsplash.com/ko/%EC%82%AC%EC%A7%84/QnUywvDdI1o?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText');
              },
          ),
        ],
        style: const TextStyle(
          color: Colors.white70,
        ),
      ),
    );
  }

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }
}