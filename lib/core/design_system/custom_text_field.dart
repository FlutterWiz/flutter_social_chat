import 'package:flutter/material.dart';
import 'package:flutter_social_chat/core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    required this.icon,
    this.validator,
  });
  final Function(String) onChanged;
  final String labelText;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        validator: validator,
        autocorrect: false,
        cursorColor: black,
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          labelText: labelText,
          hintText: hintText,
          iconColor: black,
          hintStyle: const TextStyle(color: black),
          labelStyle: const TextStyle(color: black),
          prefixIcon: Icon(icon, color: black),
        ),
      ),
    );
  }
}
