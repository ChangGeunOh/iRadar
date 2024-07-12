import 'package:flutter/material.dart';

class BaseBottom extends StatelessWidget {
  final VoidCallback onTapFinder;
  final VoidCallback onTapUpload;

  const BaseBottom({
    super.key,
    required this.onTapFinder,
    required this.onTapUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onTapFinder,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(top: 16, bottom: 18),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(50), // Adjust the radius as needed
            ),
          ),
          child: const Text(
            '파일 선택',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: onTapUpload,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24,),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(50), // Adjust the radius as needed
            ),
          ),
          child: const Text(
            '업로드',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


// ElevatedButton(
//             onPressed: enabledSave ? onTapSave : null,
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.only(top: 16, bottom: 18),
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius:
//                     BorderRadius.circular(50), // Adjust the radius as needed
//               ),
//             ),
//             child: const Text(
//               '저장하기',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//           )