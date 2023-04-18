import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final String? icon;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextEditingController? controller;

  const CustomTextfieldWidget({
    super.key,
    this.icon,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18.0),
          isDense: true,
          prefixIcon: icon != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(icon!),
                )
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
          prefixIconConstraints: const BoxConstraints(),
        ),
        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
