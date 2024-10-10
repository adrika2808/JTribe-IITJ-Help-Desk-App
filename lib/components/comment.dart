// import "package:flutter/material.dart";

// class Comment extends StatelessWidget {
//   final String text;
//   final String user;
//   final String time;

//   const Comment({
//     super.key,
//     required this.text,
//     required this.user,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: BorderRadius.circular(4),
//         ),
//         margin: const EdgeInsets.only(bottom: 5),
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //comment
//             Text(text),

//             const SizedBox(height: 5),

//             //user, time
//             Row(
//               children: [
//                 Text(
//                   user,
//                   style: TextStyle(color: Colors.grey[400]),
//                 ),
//                 Text(
//                   " . ",
//                   style: TextStyle(color: Colors.grey[400]),
//                 ),
//                 Text(
//                   time,
//                   style: TextStyle(color: Colors.grey[400]),
//                 )
//               ],
//             ),
//           ],
//         ));
//   }
// }

//Upvote downvote 1st try:

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Comment extends StatefulWidget {
//   final String text;
//   final String user;
//   final String time;
//   final List<String> upvotes;
//   final String postId;

//   Comment({
//     Key? key,
//     required this.text,
//     required this.user,
//     required this.postId,
//     required this.upvotes,
//     required this.time,
//   }) : super(key: key);

//   @override
//   _CommentState createState() => _CommentState();
// }

// class _CommentState extends State<Comment> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   bool isUpvoted = false;
//   int _downvotes = 0;

//   //toggle like
//   void toggleUpvote() {
//     setState(() {
//       isUpvoted = !isUpvoted;
//     });

//     //Access the document in Firebase
//     DocumentReference postRef =
//         FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

//     if (isUpvoted) {
//       //if the post is now liked, add the users email to the'Likes' field
//       postRef.update({
//         'Upvotes': FieldValue.arrayUnion([currentUser?.email])
//       });
//     } else {
//       //if the post is now unliked, remove the user's email from the 'Likes' field
//       postRef.update({
//         'Upvotes': FieldValue.arrayRemove([currentUser?.email])
//       });
//     }
//   }

//   void _downvote() {
//     setState(() {
//       _downvotes++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(4),
//       ),
//       margin: const EdgeInsets.only(bottom: 5),
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Comment text
//           Text(widget.text),

//           const SizedBox(height: 5),

//           // User, time, upvote and downvote
//           Row(
//             children: [
//               Text(
//                 widget.user,
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//               Text(
//                 " . ",
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//               Text(
//                 widget.time,
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.thumb_up),
//                 onPressed: toggleUpvote,
//               ),
//               Text(_upvotes.toString()),
//               SizedBox(width: 5),
//               IconButton(
//                 icon: Icon(Icons.thumb_down),
//                 onPressed: _downvote,
//               ),
//               Text(_downvotes.toString()),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

//Try 2:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String text;
  final String user;
  final String time;
  final List<String> upvotes;
  final List<String> downvotes;
  final String commentId;
  final String postId;

  Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.commentId,
    required this.postId,
    required this.upvotes,
    required this.downvotes,
    required this.time,
  }) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isUpvoted = false;
  bool isDownvoted = false;

  Future<List<String>> getCommentIdsForPost(String postId) async {
    List<String> commentIds = [];
    QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(postId)
        .collection('Comments')
        .get();

    commentSnapshot.docs.forEach((doc) {
      commentIds.add(doc.id);
    });

    return commentIds;
  }

  void toggleUpvote() async {
    setState(() {
      isUpvoted = !isUpvoted;
      if (isDownvoted) {
        // If downvoted, cancel downvote
        isDownvoted = false;
      }
    });
    List<String> commentIds = await getCommentIdsForPost(widget.postId);
    // Access the document in Firestore
    commentIds.forEach((element) {
      DocumentReference commentRef = FirebaseFirestore.instance
          .collection("User Posts")
          .doc(widget.postId)
          .collection("Comments")
          .doc(element);
      if (isUpvoted) {
        // Add user's email to the 'Upvotes' array
        commentRef.update({
          'upvotes': FieldValue.arrayUnion([currentUser?.email])
        });
      } else {
        // Remove user's email from the 'Upvotes' array
        commentRef.update({
          'upvotes': FieldValue.arrayRemove([currentUser?.email])
        });
      }
    });
    // DocumentReference commentRef = FirebaseFirestore.instance
    //     .collection("User Posts")
    //     .doc(widget.postId)
    //     .collection("Comments")
    //     .doc(commentIds[0]); // Assuming each comment has a unique ID

    // if (isUpvoted) {
    //   // Add user's email to the 'Upvotes' array
    //   commentRef.update({
    //     'upvotes': FieldValue.arrayUnion([currentUser?.email])
    //   });
    // } else {
    //   // Remove user's email from the 'Upvotes' array
    //   commentRef.update({
    //     'upvotes': FieldValue.arrayRemove([currentUser?.email])
    //   });
    // }
  }

  void toggleDownvote() {
    setState(() {
      isDownvoted = !isDownvoted;
      if (isUpvoted) {
        // If upvoted, cancel upvote
        isUpvoted = false;
      }
    });

    // Access the document in Firestore
    DocumentReference commentRef = FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .doc(widget.commentId); // Assuming each comment has a unique ID

    if (isDownvoted) {
      // Add user's email to the 'Downvotes' array
      commentRef.update({
        'downvotes': FieldValue.arrayUnion([currentUser?.email])
      });
    } else {
      // Remove user's email from the 'Downvotes' array
      commentRef.update({
        'downvotes': FieldValue.arrayRemove([currentUser?.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment text
          Text(widget.text),

          const SizedBox(height: 5),

          // User, time, upvote and downvote
          Row(
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                " . ",
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                widget.time,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_circle_up),
                    onPressed: toggleUpvote,
                    color: isUpvoted ? Colors.blue : null,
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  //like count
                  Text(
                    widget.upvotes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(width: 5),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_circle_down),
                    onPressed: toggleDownvote,
                    color: isDownvoted ? Colors.red : null,
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  //like count
                  Text(
                    widget.downvotes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


//3rd try
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Comment extends StatefulWidget {
//   final String text;
//   final String user;
//   final String time;
//   final List<String> upvotes;
//   final List<String> downvotes;
//   final String postId;
//   final String commentId; // Add commentId

//   Comment({
//     Key? key,
//     required this.text,
//     required this.user,
//     required this.postId,
//     required this.upvotes,
//     required this.downvotes,
//     required this.time,
//     required this.commentId, // Initialize commentId
//   }) : super(key: key);

//   @override
//   _CommentState createState() => _CommentState();
// }

// class _CommentState extends State<Comment> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   bool isUpvoted = false;
//   bool isDownvoted = false;

//   void toggleUpvote() {
//     setState(() {
//       isUpvoted = !isUpvoted;
//       if (isDownvoted) {
//         // If downvoted, cancel downvote
//         isDownvoted = false;
//       }
//     });

//     // Access the document in Firestore
//     DocumentReference commentRef = FirebaseFirestore.instance
//         .collection("User Posts")
//         .doc(widget.postId)
//         .collection("Comments")
//         .doc(widget.commentId); // Use commentId

//     if (isUpvoted) {
//       // Add user's email to the 'Upvotes' array
//       commentRef.update({
//         'upvotes': FieldValue.arrayUnion([currentUser?.email])
//       });
//     } else {
//       // Remove user's email from the 'Upvotes' array
//       commentRef.update({
//         'upvotes': FieldValue.arrayRemove([currentUser?.email])
//       });
//     }
//   }

//   void toggleDownvote() {
//     setState(() {
//       isDownvoted = !isDownvoted;
//       if (isUpvoted) {
//         // If upvoted, cancel upvote
//         isUpvoted = false;
//       }
//     });

//     // Access the document in Firestore
//     DocumentReference commentRef = FirebaseFirestore.instance
//         .collection("User Posts")
//         .doc(widget.postId)
//         .collection("Comments")
//         .doc(widget.commentId); // Use commentId

//     if (isDownvoted) {
//       // Add user's email to the 'Downvotes' array
//       commentRef.update({
//         'downvotes': FieldValue.arrayUnion([currentUser?.email])
//       });
//     } else {
//       // Remove user's email from the 'Downvotes' array
//       commentRef.update({
//         'downvotes': FieldValue.arrayRemove([currentUser?.email])
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(4),
//       ),
//       margin: const EdgeInsets.only(bottom: 5),
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Comment text
//           Text(widget.text),

//           const SizedBox(height: 5),

//           // User, time, upvote and downvote
//           Row(
//             children: [
//               Text(
//                 widget.user,
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//               Text(
//                 " . ",
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//               Text(
//                 widget.time,
//                 style: TextStyle(color: Colors.grey[400]),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.thumb_up),
//                 onPressed: toggleUpvote,
//                 color: isUpvoted ? Colors.blue : null,
//               ),
//               SizedBox(width: 5),
//               IconButton(
//                 icon: Icon(Icons.thumb_down),
//                 onPressed: toggleDownvote,
//                 color: isDownvoted ? Colors.red : null,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
