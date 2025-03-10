import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/common/utils/extension.dart';

import '../../../../data/repository/repository.dart';
import '../../../../domain/model/enum/wireless_type.dart';
import '../../../../domain/model/map/area_data.dart';

class AreaDialog extends StatefulWidget {
  const AreaDialog({
    super.key,
  });

  @override
  _AreaDialogState createState() => _AreaDialogState();
}

class _AreaDialogState extends State<AreaDialog> {
  final textController = TextEditingController();

  List<AreaData> areaList = [];
  List<AreaData> filteredAreaList = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final Repository repository = context.read();
    final response = await repository.getSearchArea();
    if (response.meta.code == 200) {
      areaList = response.data!;
      filteredAreaList = areaList;
    }
    setState(() {});
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        4.0), // Adjust the radius to your liking
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: textController.value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            textController.clear();
                            setState(() {
                              filteredAreaList = areaList;
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
                onChanged: (text) {
                  setState(() {
                    filteredAreaList = areaList
                        .where((element) => element.name.contains(text))
                        .toList();
                  });
                },
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final areaData = filteredAreaList[index];
                    return ListTile(
                      title: Row(
                        children: [
                          Text(areaData.name),
                          const Spacer(),
                          if (areaData.type != WirelessType.w5G)
                            SvgPicture.asset(
                              'assets/icons/ic_lte.svg',
                            ),
                          if (areaData.type == WirelessType.w5G)
                            const SizedBox(width: 32),
                          const SizedBox(width: 4),
                          if (areaData.type != WirelessType.wLte)
                            SvgPicture.asset(
                              'assets/icons/ic_5g.svg',
                              width: 32,
                            ),
                          if (areaData.type == WirelessType.wLte)
                            const SizedBox(width: 32),
                        ],
                      ),
                      onTap: () {
                        context.pop(areaData);
                      },
                      subtitle: Row(
                        children: [
                          Text(areaData.division!.name),
                          const Spacer(),
                          Text(filteredAreaList[index]
                              .createdAt!
                              .toDateString()),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: filteredAreaList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
