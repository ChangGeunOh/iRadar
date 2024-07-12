import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui_web' as ui;
import 'dart:html' as html;

class OpenSourceScreen extends StatelessWidget {
  OpenSourceScreen({super.key}) {
    _init();
  }

  _init() async {
    var iframe = html.IFrameElement()
      ..style.border = 'none';
    ui.platformViewRegistry.registerViewFactory('iframe', (int viewId) {
      return iframe;
    });
    String fileText =
        await rootBundle.loadString('assets/files/open_source_license.htm');
    iframe.srcdoc = fileText;
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
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
        Divider(
          height: 48,
          color: Colors.grey,
        ),
        SizedBox(height: 16),
        Expanded(child: HtmlElementView(viewType: 'iframe')),
      ],
    );
  }
}
