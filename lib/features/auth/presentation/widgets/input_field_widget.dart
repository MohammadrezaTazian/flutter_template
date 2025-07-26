import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? initialValue;
  final int? maxLength;

  const InputFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
    this.initialValue,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          maxLength: maxLength,
          onChanged: onChanged,
        ),
      ],
    );
  }
}