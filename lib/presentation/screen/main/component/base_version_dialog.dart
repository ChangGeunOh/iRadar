import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repository/repository.dart';
import '../../../../domain/model/base/base_version_data.dart';

class BaseVersionDialog extends StatefulWidget {
  const BaseVersionDialog({super.key});

  @override
  State<BaseVersionDialog> createState() => _BaseVersionDialogState();
}

class _BaseVersionDialogState extends State<BaseVersionDialog> {
  late final Repository _repository;
  BaseVersionData? _baseVersionData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = context.read<Repository>();
    _init();
  }

  void _init() async {
    try {
      final response = await _repository.getBaseVersion();
      if (response.meta.code == 200 && mounted) {
        setState(() {
          _baseVersionData = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNewVersion = _baseVersionData != null &&
        (_baseVersionData!.view5g != _baseVersionData!.table5g ||
            _baseVersionData!.viewLte != _baseVersionData!.tableLte);
    // final hasNewVersion = false;

    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (제목 + 닫기 버튼)
          Row(
            children: [
              const Icon(
                Icons.system_update_alt_rounded,
                color: Colors.blueAccent,
                size: 32, // 아이콘 크기 확대
              ),
              const SizedBox(width: 12),
              const Text(
                '5G/LTE RU 버전 정보',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22, // 폰트 크기 확대
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 48),

          // 2. Body (로딩/데이터 표시)
          if (_isLoading)
            const SizedBox(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            )
          else if (_baseVersionData == null)
            const SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  '버전 정보를 불러올 수 없습니다.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else ...[
              _buildVersionCard(
                title: '현재 적용 버전',
                icon: Icons.history_rounded,
                iconColor: const Color(0xFF708090),
                ru5g: _baseVersionData!.table5g,
                ruLte: _baseVersionData!.tableLte,
                backgroundColor: const Color(0xFFF8F9FA),
                borderColor: const Color(0xFFE9ECEF),
              ),
              const SizedBox(height: 32),
              _buildVersionCard(
                title: '최신 배포 버전',
                icon: Icons.new_releases_rounded,
                iconColor: hasNewVersion ? Colors.orange : Colors.green,
                ru5g: _baseVersionData!.view5g,
                ruLte: _baseVersionData!.viewLte,
                backgroundColor: hasNewVersion
                    ? const Color(0xFFFFF8F0)
                    : const Color(0xFFF4FBF7),
                borderColor: hasNewVersion
                    ? const Color(0xFFFFE8D1)
                    : const Color(0xFFD3F2E3),
                badgeText: hasNewVersion ? '업데이트 가능' : '최신 버전',
                badgeColor: hasNewVersion ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 48),
              Spacer(),
              // 3. Action Button
              SizedBox(
                width: double.infinity,
                height: 54, // 버튼 높이 확장 (50 -> 54)
                child: ElevatedButton.icon(
                  onPressed: hasNewVersion ? () async {
                    print('Download button pressed');
                    setState(() {
                      _isLoading = true;
                    });
                    final  responseData = await _repository.updateBaseData();
                    if (responseData.meta.code == 200) {
                      _baseVersionData = responseData.data;
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  } : null,
                  icon: const Icon(Icons.download_rounded, size: 22),
                  label: Text(
                    hasNewVersion ? '최신 버전으로 업데이트' : '최신 버전 적용 완료',
                    style: const TextStyle(
                      fontSize: 17, // 폰트 크기 확대
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    disabledBackgroundColor: Colors.grey.shade200,
                    disabledForegroundColor: Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
        ],
      ),
    );
  }

  Widget _buildVersionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String ru5g,
    required String ruLte,
    required Color backgroundColor,
    required Color borderColor,
    String? badgeText,
    Color? badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(32), // 내부 여백 확장 (16 -> 20)
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade800,
                ),
              ),
              if (badgeText != null) ...[
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor?.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNetworkItem(
                  tag: '5G RU',
                  tagColor: Colors.purple.shade700,
                  tagBgColor: Colors.purple.shade50,
                  value: ru5g,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNetworkItem(
                  tag: 'LTE RU',
                  tagColor: Colors.blue.shade700,
                  tagBgColor: Colors.blue.shade50,
                  value: ruLte,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkItem({
    required String tag,
    required Color tagColor,
    required Color tagBgColor,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: tagBgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tagColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 18, // 폰트 크기 확대
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
