import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  bool obscureText = false;
  Function? onFocus;
  final IconData icon;
  TextEditingController controller;
  final TextInputType keyboardType;

  CustomTextField(
      {super.key,
      required this.label,
      required this.controller,
      required this.hint,
      required this.icon,
      this.keyboardType = TextInputType.text,
      this.onFocus,
      this.obscureText = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode _focus = FocusNode();

  void _onFocusChange() {
    widget.onFocus?.call();
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      focusNode: _focus,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          color: Colors.black,
        ),
        hintText: widget.hint,
      ),
    );
  }
}
