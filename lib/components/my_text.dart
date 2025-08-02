import 'package:flutter/material.dart';

class MyText {
  /// Title text (e.g., for AppBar or page titles)
  static Text title(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'CantataOne',
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black,
      ),
    );
  }

  /// Body text (e.g., for general content)
  static Text body(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: color ?? Colors.black87,
        fontFamily: 'CantataOne',
      ),
    );
  }

  /// Small caption or helper text
  static Text small(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: color ?? Colors.grey,
        fontFamily: 'CantataOne',
      ),
    );
  }
}
