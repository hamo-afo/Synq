import 'package:flutter/material.dart';
import 'add_comment_widget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Detail")),
      body: Column(
        children: [
          Expanded(
            child: ListView(children: const [Text("Post Details Here")]),
          ),
          AddCommentWidget(
            controller: commentController,
            onSubmit: () {
              // TODO: submit comment
            },
          ),
        ],
      ),
    );
  }
}
