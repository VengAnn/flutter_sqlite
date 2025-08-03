import 'package:flutter/material.dart';

import '../components/my_text.dart';

class MyRowOne extends StatelessWidget {
  final String titleName;
  final Widget? widget;
  final bool hideDivider;

  const MyRowOne({
    required this.titleName,
    required this.widget,
    this.hideDivider = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // title name
            MyText.body(titleName),
            // Widget
            widget ?? const SizedBox.shrink(),
          ],
        ),
        // Divider
        if (!hideDivider)
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
      ],
    );
  }
}
