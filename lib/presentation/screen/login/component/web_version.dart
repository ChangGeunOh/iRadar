import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class WebVersion extends StatefulWidget {
  const WebVersion({super.key});

  @override
  State<WebVersion> createState() => _WebVersionState();
}

class _WebVersionState extends State<WebVersion> {
  String currentVersion = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Version: $currentVersion',
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
