import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OpenSourceScreen extends StatelessWidget {
  const OpenSourceScreen({super.key});

  static const String _licenseAssetPath = 'assets/files/open_source_license.htm';

  // HTML 전체 렌더링 대신, 라이선스 표시 목적에 맞게 태그를 제거해 텍스트로 보여준다.
  // (DOM/iframe(HtmlElementView) 의존을 제거하여 wasm 호환성을 높임)
  String _htmlToPlainText(String html) {
    var text = html
        // script/style 제거
        .replaceAll(RegExp(r'<(script|style)[^>]*>[\s\S]*?</\1>', caseSensitive: false), '')
        // <br>, <p>, <div> 등 줄바꿈 처리
        .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<\s*/p\s*>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<\s*/div\s*>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<\s*li\s*>', caseSensitive: false), '• ')
        .replaceAll(RegExp(r'<\s*/li\s*>', caseSensitive: false), '\n')
        // 나머지 태그 제거
        .replaceAll(RegExp(r'<[^>]+>'), '')
        // HTML 엔티티 일부 처리
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // 공백/줄바꿈 정리
    text = text
        .replaceAll(RegExp(r'\r\n?'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            '오픈소스 라이센스',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
        ),
        const Divider(
          height: 48,
          color: Colors.grey,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<String>(
            future: rootBundle.loadString(_licenseAssetPath),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '라이선스 파일을 불러오지 못했습니다.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }

              final html = snapshot.data ?? '';
              final text = _htmlToPlainText(html);

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectionArea(
                  child: SingleChildScrollView(
                    child: Text(
                      text.isEmpty ? '(내용 없음)' : text,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
