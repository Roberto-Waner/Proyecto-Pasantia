import 'package:flutter/material.dart';

class UpperCaseTextEditingController extends TextEditingController {
  @override
  set text(String newText) {
    super.text = newText.toUpperCase();
  }
  
  void setValue(TextEditingValue newValue) {
    super.value = newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}
