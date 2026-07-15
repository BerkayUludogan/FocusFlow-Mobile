import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';

class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: WidgetSizes.buttonLoadingIndicatorSize,
      height: WidgetSizes.buttonLoadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: WidgetSizes.buttonLoadingIndicatorStrokeWidth,
        color: Colors.white,
      ),
    );
  }
}
