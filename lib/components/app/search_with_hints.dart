import 'package:flutter/material.dart';

class SearchWithHints extends StatelessWidget {
  final String label;
  final String? hintText;
  final List<String> options;
  final Function(String) onSelected;
  final TextEditingController controller;

  const SearchWithHints({
    super.key,
    required this.options,
    required this.label,
    required this.onSelected,
    this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String text) {
        onSelected(text);
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                hintText: hintText,
                border: const OutlineInputBorder(),
              ),
            );
          },
    );
  }
}
