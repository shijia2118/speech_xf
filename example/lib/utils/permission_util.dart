import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  ///权限申请:麦克风
  static microPhone(
    BuildContext context, {
    required Function action,
  }) async {
    PermissionStatus status = await Permission.microphone.status;
    if (status.isGranted) {
      await action();
    } else {
      status = await Permission.microphone.request();
      if (status.isGranted) {
        await action();
      }
    }
  }
}
