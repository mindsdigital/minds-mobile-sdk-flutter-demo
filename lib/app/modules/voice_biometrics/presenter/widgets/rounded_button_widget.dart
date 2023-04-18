import 'package:flutter/material.dart';
import '../../../../core/presenter/theme/minds_colors.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  final bool enabled;

  const RoundedButtonWidget({
    Key? key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.foregroundColor,
    this.enabled = true,
    required this.onPressed,
  }) : super(key: key);

  const RoundedButtonWidget.blue({
    Key? key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  })  : backgroundColor = MindsColors.blue,
        textColor = null,
        foregroundColor = null,
        super(key: key);

  const RoundedButtonWidget.green({
    Key? key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  })  : foregroundColor = Colors.white,
        backgroundColor = MindsColors.green,
        textColor = Colors.white,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: const StadiumBorder(),
        ),
        child: Text(label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
