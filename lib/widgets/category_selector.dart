import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final Function(String) onSelect;

  const CategorySelector({super.key, required this.onSelect});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = [
    "Technology",
    "Sports",
    "Education",
    "Entertainment",
    "Science",
    "Lifestyle",
    "Other",
  ];

  String selected = "";

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: categories.map((cat) {
        final isSelected = cat == selected;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (_) {
            setState(() => selected = cat);
            widget.onSelect(cat);
          },
        );
      }).toList(),
    );
  }
}
