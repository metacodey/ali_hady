// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class McOtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final String? valueValidator;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final double width;
  final double height;

  const McOtpInput(
      {super.key,
      required this.controller,
      this.autoFocus = false,
      this.valueValidator,
      this.onChanged,
      this.height = 60,
      this.width = 50,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextFormField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        validator: valueValidator == null
            ? validator
            : (value) {
                if (value == null || value.isEmpty) {
                  return valueValidator;
                }
                return null;
              },
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
