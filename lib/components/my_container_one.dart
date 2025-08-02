import 'package:flutter/material.dart';

import '../utils/font_style.dart';

class MyContainerOne extends StatelessWidget {
  final String? title;
  final Widget? widget;

  const MyContainerOne({super.key, this.title, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title optional
          title == null
              ? SizedBox.shrink()
              : Text(title.toString(), style: titleTextStyle),

          // widget
          widget ?? SizedBox.shrink(),
        ],
      ),
    );
  }
}
