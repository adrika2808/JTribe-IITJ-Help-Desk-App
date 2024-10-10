// import "package:cloud_firestore/cloud_firestore.dart";
// import "package:dcapp/components/comment.dart";
// import "package:dcapp/components/comment_button.dart";
// import "package:dcapp/components/like_button.dart";
// import "package:firebase_auth/firebase_auth.dart";
// import "package:flutter/cupertino.dart";
// import "package:flutter/material.dart";
// import "package:flutter/widgets.dart";

// class WallPost extends StatefulWidget {
//   final String message;
//   final String user;
//   final String time;
//   final String postId;
//   final List<String> Likes;
//   final String category;

//   const WallPost({
//     super.key,
//     required this.message,
//     required this.user,
//     required this.time,
//     required this.postId,
//     required this.Likes,
//     required this.category,
//   });

//   @override
//   State<WallPost> createState() => _WallPostState();
// }

// class _WallPostState extends State<WallPost> {
//   //user
//   final currentUser = FirebaseAuth.instance.currentUser;
//   bool isLiked = false;
//   bool isRepliesExpanded = false;

//   //comment text controller
//   final _commentTextController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     isLiked = widget.Likes.contains(currentUser?.email);
//   }

//   //toggle like
//   void toggleLike() {
//     setState(() {
//       isLiked = !isLiked;
//     });

//     //Access the document in Firebase
//     DocumentReference postRef =
//         FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

//     if (isLiked) {
//       //if the post is now liked, add the users email to the'Likes' field
//       postRef.update({
//         'Likes': FieldValue.arrayUnion([currentUser?.email])
//       });
//     } else {
//       //if the post is now unliked, remove the user's email from the 'Likes' field
//       postRef.update({
//         'Likes': FieldValue.arrayRemove([currentUser?.email])
//       });
//     }
//   }

//   //add a comment
//   void addComment(String commentText) {
//     //write the comment to firestore under the comments collection for this post
//     FirebaseFirestore.instance
//         .collection("User Posts")
//         .doc(widget.postId)
//         .collection("Comments")
//         .add({
//       "CommentText": commentText,
//       "CommentedBy": currentUser?.email,
//       "CommentTime": Timestamp.now(), //remember to format when displaying
//     });
//   }

//   //show a dialog box for adding comment
//   void showCommentDialog() {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text("Add your Reply"),
//               content: TextField(
//                 controller: _commentTextController,
//                 decoration: InputDecoration(hintText: "Write a reply..."),
//               ),
//               actions: [
//                 //cancel button
//                 TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);

//                       //clear controller
//                       _commentTextController.clear();
//                     },
//                     child: Text("Cancel")),
//                 //post button
//                 TextButton(
//                     onPressed: () {
//                       addComment(_commentTextController.text);

//                       //pop box
//                       Navigator.pop(context);

//                       //clear controller
//                       _commentTextController.clear();
//                     },
//                     child: Text("Post")),
//               ],
//             ));
//   }

//   String formatDate(Timestamp timestamp) {
//     //Timestamp is the object we retrieve from firebase
//     //so to display it, lets convert it to a string
//     DateTime dateTime = timestamp.toDate();

//     //get year
//     String year = dateTime.year.toString();

//     //get month
//     String month = dateTime.month.toString();

//     //get day
//     String day = dateTime.day.toString();

//     //final formatted date
//     String formattedData = '$day/$month/$year';

//     return formattedData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       margin: EdgeInsets.only(top: 25, left: 25, right: 25),
//       padding: EdgeInsets.all(25),
//       child: Column(
//         //wall post
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           //message and user email
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //message
//               Text(
//                 widget.message,
//                 style: TextStyle(fontWeight: FontWeight.w700),
//               ),

//               const SizedBox(
//                 height: 5,
//               ),

//               //user
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         widget.user,
//                         style: TextStyle(color: Colors.grey[400]),
//                       ),
//                       Text(
//                         " . ",
//                         style: TextStyle(color: Colors.grey[400]),
//                       ),
//                       Text(
//                         widget.time,
//                         style: TextStyle(color: Colors.grey[400]),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     widget.category,
//                     style: TextStyle(color: Colors.grey[400]),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           const SizedBox(
//             height: 20,
//           ),

//           //buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               //LIKE
//               Column(
//                 children: [
//                   //like button
//                   LikeButton(
//                     isLiked: isLiked,
//                     onTap: toggleLike,
//                   ),

//                   const SizedBox(
//                     height: 5,
//                   ),

//                   //like count
//                   Text(
//                     widget.Likes.length.toString(),
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),

//               const SizedBox(
//                 width: 10,
//               ),

//               //COMMENT
//               Column(
//                 children: [
//                   //comment button
//                   CommentButton(onTap: showCommentDialog),

//                   const SizedBox(
//                     height: 5,
//                   ),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection("User Posts")
//                         .doc(widget.postId)
//                         .collection("Comments")
//                         .snapshots(),
//                     builder: ((context, snapshot) {
//                       // Show loading indicator while data is being fetched
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return CircularProgressIndicator();
//                       }
//                       // Handle error if any
//                       if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       }
//                       // Get the number of comments
//                       int commentCount = snapshot.data!.docs.length;
//                       return Text(
//                         commentCount.toString(),
//                         style: TextStyle(color: Colors.grey),
//                       );
//                     }),
//                   ),
//                   //comment count
//                   // Text(
//                   //   commentCount.toString(),
//                   //   style: TextStyle(color: Colors.grey),
//                   // ),
//                 ],
//               ),
//             ],
//           ),

//           const SizedBox(
//             height: 20,
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 isRepliesExpanded = !isRepliesExpanded;
//               });
//             },
//             child: Row(
//               children: [
//                 const Text(
//                   "Replies",
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 Icon(isRepliesExpanded
//                     ? Icons.arrow_drop_up
//                     : Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           //comments under the post
//           if (isRepliesExpanded)
//             StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("User Posts")
//                     .doc(widget.postId)
//                     .collection("Comments")
//                     .orderBy("CommentTime", descending: true)
//                     .snapshots(),
//                 builder: ((context, snapshot) {
//                   //show loaing circle
//                   if (!snapshot.hasData) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   }
//                   return ListView(
//                     shrinkWrap: true, //for nested lists
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: snapshot.data!.docs.map((doc) {
//                       //get the comment
//                       final commentData = doc.data() as Map<String, dynamic>;

//                       //return the comment

//                       return Comment(
//                         text: commentData["CommentText"],
//                         user: commentData["CommentedBy"],
//                         time: formatDate(commentData["CommentTime"]),
//                         // upvotes: [],
//                         // downvotes: [],
//                         // postId: widget.postId,
//                       );
//                     }).toList(),
//                   );
//                 }))
//         ],
//       ),
//     );
//   }
// }

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dcapp/components/comment.dart";
import "package:dcapp/components/comment_button.dart";
import "package:dcapp/components/like_button.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final String commentId;
  final List<String> likes;
  final String category;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
    required this.commentId,
    required this.category,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  bool isRepliesExpanded = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser?.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      //if the post is now liked, add the users email to the'Likes' field
      postRef.update({
        'Flags': FieldValue.arrayUnion([currentUser?.email])
      });
    } else {
      //if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Flags': FieldValue.arrayRemove([currentUser?.email])
      });
    }
  }

  //add a comment
  void addComment(String commentText) async {
    //write the comment to firestore under the comments collection for this post
    if (commentText.isNotEmpty) {
      String commentId = widget.postId + "1";
      await FirebaseFirestore.instance
          .collection("User Posts")
          .doc(widget.postId)
          .collection("Comments")
          .add({
        "CommentText": commentText,
        "CommentedBy": currentUser?.email,
        "CommentTime": Timestamp.now(),
        "CommentId": commentId,
        "upvotes": [],
        "downvotes": [], //remember to format when displaying
      });
    }
  }

  //show a dialog box for adding comment
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add your Reply"),
              content: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(hintText: "Write a reply..."),
              ),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      //clear controller
                      _commentTextController.clear();
                    },
                    child: Text("Cancel")),
                //post button
                TextButton(
                    onPressed: () {
                      addComment(_commentTextController.text);

                      //pop box
                      Navigator.pop(context);

                      //clear controller
                      _commentTextController.clear();
                    },
                    child: Text("Post")),
              ],
            ));
  }

  String formatDate(Timestamp timestamp) {
    //Timestamp is the object we retrieve from firebase
    //so to display it, lets convert it to a string
    DateTime dateTime = timestamp.toDate();

    //get year
    String year = dateTime.year.toString();

    //get month
    String month = dateTime.month.toString();

    //get day
    String day = dateTime.day.toString();

    //final formatted date
    String formattedData = '$day/$month/$year';

    return formattedData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        //wall post
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //message
              Text(
                widget.message,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),

              const SizedBox(
                height: 5,
              ),

              //user
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.category,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LIKE
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  //like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(
                width: 10,
              ),

              //COMMENT
              Column(
                children: [
                  //comment button
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(
                    height: 5,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .snapshots(),
                    builder: ((context, snapshot) {
                      // Show loading indicator while data is being fetched
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      // Handle error if any
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Get the number of comments
                      int commentCount = snapshot.data!.docs.length;
                      return Text(
                        commentCount.toString(),
                        style: TextStyle(color: Colors.grey),
                      );
                    }),
                  ),
                  //comment count
                  // Text(
                  //   commentCount.toString(),
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isRepliesExpanded = !isRepliesExpanded;
              });
            },
            child: Row(
              children: [
                const Text(
                  "Replies",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Icon(isRepliesExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //comments under the post
          if (isRepliesExpanded)
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  //show loaing circle
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return ListView(
                    shrinkWrap: true, //for nested lists
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      //get the comment
                      final commentData = doc.data() as Map<String, dynamic>;

                      //return the comment
                      return Comment(
                        text: commentData["CommentText"],
                        user: commentData["CommentedBy"],
                        time: formatDate(commentData["CommentTime"]),
                        upvotes: [],
                        downvotes: [],
                        postId: widget.postId,
                        commentId: widget.commentId,
                      );
                    }).toList(),
                  );
                }))
        ],
      ),
    );
  }
}
