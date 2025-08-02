import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final bool isPassword;
  final bool hideBorder;
  final bool hideLabel;

  const CustomTextField({
    super.key,
    required this.controller,
     this.label,
    this.isPassword = false,
    this.hideBorder = false,
    this.hideLabel = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.4),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          labelText: hideLabel ? null : label,
          labelStyle: const TextStyle(fontSize: 16),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'CantataOne',
            fontWeight: FontWeight.w900,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: hideBorder
              ? InputBorder.none
              : OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: hideBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
        ),
      ),
    );
  }
}
