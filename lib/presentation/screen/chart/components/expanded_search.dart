import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpandedSearch extends StatefulWidget {
  final ValueChanged onSearchValue;

  const ExpandedSearch({
    required this.onSearchValue,
    super.key,
  });

  @override
  State<ExpandedSearch> createState() => _ExpandedSearchState();
}

class _ExpandedSearchState extends State<ExpandedSearch> {
  var isExpanded = false;
  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          width: isExpanded ? 80 : 0,
          duration: const Duration(milliseconds: 200),
          alignment: isExpanded
              ? AlignmentDirectional.centerStart
              : AlignmentDirectional.centerEnd,
          curve: Curves.fastOutSlowIn,
          child: TextField(
            onChanged: (value) => widget.onSearchValue(value),
            onSubmitted: (value) => widget.onSearchValue(value),
            decoration: const InputDecoration(labelText: 'RSRP Gap'),
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        IconButton(
          onPressed: (){
            setState(() {
              isExpanded = !isExpanded;
              if (isExpanded) {
                focusNode.requestFocus();
              } else {
                focusNode.unfocus();
              }
            });
          },
          icon: Icon(
            isExpanded ? Icons.close_rounded : Icons.search_rounded,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
