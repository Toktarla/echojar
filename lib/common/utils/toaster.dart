import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'toaster_body.dart';

/// This line declares a global variable which is used to show toast messages.
final FToast fToast = FToast();

final class Toaster {
  const Toaster._();

  static Future<void> showToast({
    required String title,
    Color backgroundColor = const Color.fromARGB(255, 43, 42, 42),
    Color textColor = Colors.white,
    bool hasImage = true,
    bool isDismissible = true,
    bool isIgnorePointer = true,
    Duration fadeDuration = const Duration(milliseconds: 200),
    Duration toastDuration = const Duration(seconds: 1),
    ToastGravity gravity = ToastGravity.BOTTOM,
    VoidCallback? then,
  }) async {
    fToast
      ..removeCustomToast()
      ..showToast(
        child: _ToasterBody(
          title: title,
          backgroundColor: backgroundColor,
          textColor: textColor,
          hasImage: hasImage,
        ),
        gravity: gravity,
        fadeDuration: fadeDuration,
        toastDuration: toastDuration,
        ignorePointer: isIgnorePointer,
        isDismissible: isDismissible,
      );

    await Future.delayed(toastDuration, () {
      if (then != null) {
        then.call();
      }
    });
  }

  static Future<void> showSuccessToast(
      BuildContext context, {
        required String title,
        VoidCallback? then,
        Color textColor = Colors.white,
        bool hasImage = false,
        bool isDismissible = true,
        bool isIgnorePointer = true,
        Duration fadeDuration = const Duration(milliseconds: 200),
        Duration toastDuration = const Duration(milliseconds: 1500),
        ToastGravity gravity = ToastGravity.BOTTOM,
      }) async {
    fToast
      ..removeCustomToast()
      ..showToast(
        child: _ToasterBody(
          title: title,
          // backgroundColor: context.colors.success,
          backgroundColor: Colors.greenAccent,
          textColor: textColor,
          hasImage: hasImage,
        ),
        gravity: gravity,
        fadeDuration: fadeDuration,
        toastDuration: toastDuration,
        ignorePointer: isIgnorePointer,
        isDismissible: isDismissible,
      );

    await Future.delayed(toastDuration, () {
      if (then != null) {
        then.call();
      }
    });
  }

  static Future<void> showErrorToast(
      BuildContext context, {
        required String title,
        VoidCallback? then,
        Color textColor = Colors.white,
        bool hasImage = false,
        bool isDismissible = true,
        bool isIgnorePointer = true,
        Duration fadeDuration = const Duration(milliseconds: 200),
        Duration toastDuration = const Duration(milliseconds: 1500),
        ToastGravity gravity = ToastGravity.BOTTOM,
      }) async {
    fToast
      ..removeCustomToast()
      ..showToast(
        child: _ToasterBody(
          title: title,
          // backgroundColor: context.colors.errorDefault,
          backgroundColor: Colors.redAccent,
          textColor: textColor,
          hasImage: hasImage,
        ),
        gravity: gravity,
        fadeDuration: fadeDuration,
        toastDuration: toastDuration,
        ignorePointer: isIgnorePointer,
        isDismissible: isDismissible,
      );

    await Future.delayed(toastDuration, () {
      if (then != null) {
        then.call();
      }
    });
  }
}
