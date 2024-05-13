import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../config/app_duration.dart';

void showBasicSuccessSnackBar({
  required String message,
  Widget? icon,
  Function()? onActionTap,
  String buttonText = '',
  double time = 2,
  String? title,
  bool positionTop = true,
}) {
  if (Get.isSnackbarOpen) {
    return;
  }
  Get.rawSnackbar(
    backgroundColor: Colors.green,
    icon: icon ??
        const Icon(
          Icons.task_alt_rounded,
          color: Colors.white,
        ),
    animationDuration: AppDuration.snackBarAnimation,
    duration: time.seconds,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
    snackPosition: positionTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
    mainButton: buttonText.isEmpty
        ? const SizedBox()
        : TextButton(
            onPressed: onActionTap,
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    title: title,
  );
}

void showBasicFailedSnackBar({
  required String message,
  Widget? icon,
  Function()? onActionTap,
  String buttonText = '',
  double time = 2.5,
  bool positionTop = true,
}) {
  if (Get.isSnackbarOpen) {
    return;
  }
  Get.rawSnackbar(
    icon: icon ??
        const Icon(
          Icons.priority_high_rounded,
          color: Colors.white,
        ),
    backgroundColor: Colors.deepOrangeAccent,
    animationDuration: 200.milliseconds,
    duration: 2.5.seconds,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
    snackPosition: positionTop ? SnackPosition.TOP : SnackPosition.BOTTOM,
    mainButton: buttonText.isEmpty
        ? const SizedBox()
        : TextButton(
            onPressed: onActionTap,
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

void showBasicProgressDialog({required String message}) {
  Widget dialog = Center(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.green,
                strokeWidth: 1.5,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              message,
            ),
          ],
        ),
      ),
    ),
  );

  Get.dialog(
    dialog,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 400),
  );
}
