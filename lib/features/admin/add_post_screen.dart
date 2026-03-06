import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  String selectedCategory = "General";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final newPost = PostModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: "123", // Replace with actual user ID later
                  content: descController.text.trim(),
                  category: selectedCategory,
                  imageUrl: "",
                  createdAt: DateTime.now(),
                );

                await PostRepository().createPost(newPost);
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
