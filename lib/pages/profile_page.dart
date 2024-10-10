import "package:cloud_firestore/cloud_firestore.dart";
import "package:dcapp/components/text_box.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;
  //all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async {
    String newvalue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                "Edit $field",
                style: const TextStyle(color: Colors.white),
              ),
              content: TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Enter new $field",
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  newvalue = value;
                },
              ),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: const TextStyle(color: Colors.white))),

                //save button
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newvalue),
                    child: Text('Save',
                        style: const TextStyle(color: Colors.white)))
              ],
            ));

    //update in firestore
    if (newvalue.trim().length > 0) {
      //only update if anything in the textfield
      await usersCollection.doc(currentUser.email).update({field: newvalue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            "Profile Page",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[850],
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      //get user data
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return ListView(children: [
                          const SizedBox(
                            height: 50,
                          ),
                          //profile pic
                          Icon(
                            Icons.person,
                            size: 72,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          //user email
                          Text(
                            currentUser.email!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700]),
                          ),

                          const SizedBox(
                            height: 50,
                          ),

                          //user details
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              'My Details',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),

                          //username
                          MyTextBox(
                            text: userData['username'],
                            sectionName: 'Username',
                            onPressed: () => editField('username'),
                          ),

                          const SizedBox(
                            height: 50,
                          ),

                          //user posts
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              'My Posts',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ]);
                      } else if (snapshot.hasError) {
                        return (Center(
                          child: Text('Error${snapshot.error}'),
                        ));
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
