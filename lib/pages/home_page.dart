import "package:cloud_firestore/cloud_firestore.dart";
import "package:dcapp/components/drawer.dart";
import "package:dcapp/components/text_field.dart";
import "package:dcapp/components/wall_post.dart";
import "package:dcapp/pages/add_post_page.dart";
import "package:dcapp/pages/profile_page.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textContoller = TextEditingController();
  final searchValueController = TextEditingController();

  //sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // void postMessage() {
  //   //only post if something is there in the textfield
  //   if (textContoller.text.isNotEmpty) {
  //     //store in firebase
  //     FirebaseFirestore.instance.collection("User Posts").add({
  //       'UserEmail': currentUser.email,
  //       'Message': textContoller.text,
  //       'TimeStamp': Timestamp.now(),
  //       'Likes': [],
  //     });
  //   }

  //   //clear the textfield
  //   setState(() {
  //     textContoller.clear();
  //   });
  // }

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

  //navigate to profile page
  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
        elevation: 0,
        // actions: [
        //   //sign out button
        //   IconButton(onPressed: signOut, icon: Icon(Icons.logout))
        // ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy("TimeStamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //get the message
                          final post = snapshot.data!.docs[index];

                          return WallPost(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postId: post.id,
                            likes: List<String>.from(post['Flags'] ?? []),
                            time: formatDate(post['TimeStamp']),
                            category: post['Category'],
                            commentId: post.id,
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),

            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //post button
                        Text("Post Your Question"),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_circle_up)

                        // IconButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => PostPage(),
                        //         ),
                        //       );
                        //     },
                        //     icon: Icon(Icons.arrow_circle_up)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //logged in as
            Text("Logged in as: ${currentUser.email!}"),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
