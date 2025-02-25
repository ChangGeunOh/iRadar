import 'package:flutter/material.dart';

import '../../main.dart';
import '../const/color.dart';

mixin ShowMessageMixin {
  void showToast(String message) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rootScaffoldKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
