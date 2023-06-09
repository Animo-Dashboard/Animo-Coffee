import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  bool hasNewErrors = false;

  void updateNewErrorsStatus(bool hasNewErrors) {
    this.hasNewErrors = hasNewErrors;
    notifyListeners();
  }
}
