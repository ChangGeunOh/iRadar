import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/data/repository/repository.dart';
import 'package:googlemap/domain/model/upload/request_storage_data.dart';

import '../../../../common/const/color.dart';

class RequestStorageDialog extends StatefulWidget {
  const RequestStorageDialog({super.key});

  @override
  State<RequestStorageDialog> createState() => _RequestStorageDialogState();
}

class _RequestStorageDialogState extends State<RequestStorageDialog> {
  final textController = TextEditingController();
  late final Repository _repository;
  List<RequestStorageData> _storageAreaList = [];
  List<RequestStorageData> _filteredStorageAreaList = [];

  @override
  void initState() {
    _repository = context.read();
    super.initState();
    _init();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _init() async {
    final response = await _repository.getRequestStorageData();
    print(response.meta.toJson());
    if (response.meta.code == 200) {
      _storageAreaList = response.data!;
      _filteredStorageAreaList = _storageAreaList;
      setState(() {});
    }
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
                  labelText: 'NQI 서버 요청 데이터 검색',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: textController.value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            textController.clear();
                            setState(() {
                              _filteredStorageAreaList = _storageAreaList;
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
                onChanged: (value) {
                  print('value>$value');
                  setState(() {
                    _filteredStorageAreaList = _storageAreaList
                        .where(
                            (data) => data.name.toLowerCase().contains(value))
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredStorageAreaList.length,
                  itemBuilder: (context, index) {
                    final data = _filteredStorageAreaList[index];
                    return InkWell(
                        child: RequestStorageItem(
                          data: data,
                          onRemove: () {
                            _removeRequestStorageData(data.requestNumber);
                          },
                        ),
                        onTap: () {
                          context.pop(data);
                        });
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeRequestStorageData(int requestNumber) async {
    final response = await _repository.deleteRequestStorageData(requestNumber);
    if (response.meta.code == 200) {
      _storageAreaList.removeWhere((data) => data.requestNumber == requestNumber);
      setState(() {
        _filteredStorageAreaList = _storageAreaList
            .where((data) => data.name.toLowerCase().contains(textController.value.text))
            .toList();
      });
    }
  }
}

class RequestStorageItem extends StatelessWidget {
  final VoidCallback onRemove;
  final RequestStorageData data;

  const RequestStorageItem({
    super.key,
    required this.onRemove,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(data.requestNumber.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove,
            icon: Icons.delete_forever_outlined,
            backgroundColor: redColor,
            foregroundColor: Colors.white,
            label: '자료삭제',
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          height: double.infinity,
          width: 50,
          decoration: BoxDecoration(
            color: mintColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              data.division.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(data.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Row(
          children: [
            Text(data.address),
            const Spacer(),
            Text(data.startDate.toDateString()),
          ],
        ),
      ),
    );
  }
}
