import 'package:flutter/material.dart';

class AddCommentWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const AddCommentWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Add a comment"),
          ),
        ),
        IconButton(onPressed: onSubmit, icon: const Icon(Icons.send)),
      ],
    );
  }
}
