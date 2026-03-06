import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/post_model.dart';
import '../../../core/services/post_service.dart';
import '../../../widgets/category_selector.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final titleController =
      TextEditingController(); // only UI, not saved to model
  final descController = TextEditingController();

  String selectedCategory = '';
  File? selectedImage;
  bool loading = false;

  final ImagePicker _picker = ImagePicker();
  final PostService postService = PostService();

  Future<void> pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  Future<void> createPost() async {
    if (descController.text.isEmpty ||
        selectedCategory.isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("All fields are required")));
      return;
    }

    setState(() => loading = true);

    // Map UI fields to your PostModel
    final newPost = PostModel(
      id: '', // Firestore auto-generates
      userId: 'CURRENT_USER_ID', // Replace with your auth provider
      content: descController.text.trim(),
      imageUrl: null, // Upload logic not included
      createdAt: DateTime.now(),
      category: selectedCategory,
    );

    await postService.createPost(newPost);

    setState(() => loading = false);

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Post Added Successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Post")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title (optional)", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter title (not saved to database)",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Description", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter description",
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Category", style: TextStyle(fontSize: 16)),
                  CategorySelector(
                    onSelect: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Image", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: selectedImage == null
                          ? Center(child: Text("Tap to select image"))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: createPost,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Publish Post"),
                  ),
                ],
              ),
            ),
    );
  }
}
