import 'package:flutter/material.dart';

class CursorService extends ChangeNotifier {
  String _cursorText = '';
  bool _isHovering = false;

  String get cursorText => _cursorText;
  bool get isHovering => _isHovering;

  void setHovering(bool hovering, {String text = ''}) {
    _isHovering = hovering;
    _cursorText = text;
    notifyListeners();
  }
}
