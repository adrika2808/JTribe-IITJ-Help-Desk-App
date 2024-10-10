import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController textContoller = TextEditingController();
  String _selectedCategory = 'Academic';
  bool _isAnonymous = false;
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // void _submitPost() {
  //   // Here you can upload the post to your homepage
  //   // You can access the entered question, selected category, and anonymity status
  //   String question = _questionController.text;
  //   print('Question: $question');
  //   print('Category: $_selectedCategory');
  //   print('Is Anonymous: $_isAnonymous');
  //   // Add your logic here to upload the post to the homepage
  // }

  void postMessage() {
    //only post if something is there in the textfield
    if (textContoller.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': _isAnonymous ? "anonymous" : currentUser.email,
        'Message': textContoller.text,
        'TimeStamp': Timestamp.now(),
        'Flags': [],
        'Category': _selectedCategory,
      });
    }

    //clear the textfield
    setState(() {
      textContoller.clear();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Ask Your Question',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: textContoller,
              decoration: InputDecoration(
                labelText: 'Enter your question',
              ),
            ),
            SizedBox(height: 20.0),
            Text('Select Category:'),
            DropdownButtonFormField(
              hint: Text('Select Category'),
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value.toString();
                });
              },
              items: ['Academic', 'Non-Academic']
                  .map((category) => DropdownMenuItem(
                        child: Text(category),
                        value: category,
                      ))
                  .toList(),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      _isAnonymous = value!;
                    });
                  },
                ),
                Text('Post Anonymously'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: postMessage,
              child: Text(
                'Post',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
