import "package:flutter/material.dart";

class SearchWithHints extends StatelessWidget {
  const SearchWithHints({
    required this.options,
    required this.label,
    required this.onSelected,
    required this.controller,
    super.key,
    this.hintText,
  });
  final String label;
  final String? hintText;
  final List<String> options;
  final Function(String) onSelected;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Autocomplete<String>(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text == "") {
        return const Iterable<String>.empty();
      }
      return options.where(
        (String option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()),
      );
    },
    onSelected: onSelected,
    fieldViewBuilder:
        (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          onFieldSubmitted,
        ) => TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
  );
}
