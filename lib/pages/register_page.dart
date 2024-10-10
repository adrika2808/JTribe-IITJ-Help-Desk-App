import "package:cloud_firestore/cloud_firestore.dart";
import "package:dcapp/components/button.dart";
import "package:dcapp/components/text_field.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:email_otp/email_otp.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmpasswordTextController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  EmailOTP emailAuth = EmailOTP();

  void sendOTP() async {
    if (emailTextController.text.contains("@iitj.ac.in")) {
      emailAuth.setConfig(
          // appEmail: "kunjumon.1@iitj.ac.in",
          appName: "Email OTP",
          userEmail: emailTextController.text,
          otpLength: 4,
          otpType: OTPType.digitsOnly);
      emailAuth.setTheme(theme: "v2");

      if (await emailAuth.sendOTP() == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP has been sent"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Oops, OTP send failed"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Only IITJ users allowed! Please try again using your IITJ Email ID."),
      ));
    }
  }

  void verifyOTP() async {
    if (await emailAuth.verifyOTP(otp: otpController.text) == true) {
      showDialog(
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ));

      //make sure passwords match
      if (passwordTextController.text != confirmpasswordTextController.text) {
        //pop loading circle
        Navigator.pop(context);
        //show error to user
        displayMessage("Passwords don't match!");
        return;
      }
      //try creating user
      try {
        //create the user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextController.text,
                password: passwordTextController.text);

        //after creating the user, create a new document in cloud firestore called Users
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user?.email!)
            .set({
          'username': emailTextController.text.split('@')[0],
        });
        //pop loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop loading circle
        Navigator.pop(context);
        //display error message
        displayMessage(e.code);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
  }

  // //sign user up
  // void signUp() async {
  //   //show loading circle
  //   showDialog(
  //       context: context,
  //       builder: (context) => const Center(
  //             child: CircularProgressIndicator(),
  //           ));

  //   //make sure passwords match
  //   if (passwordTextController.text != confirmpasswordTextController.text) {
  //     //pop loading circle
  //     Navigator.pop(context);
  //     //show error to user
  //     displayMessage("Passwords don't match!");
  //     return;
  //   }

  //   //make sure iitj email
  //   if (!emailTextController.text.contains('@iitj.ac.in')) {
  //     //pop loading circle
  //     Navigator.pop(context);
  //     //show error to user
  //     displayMessage(
  //         "Only IITJ users allowed! Please try again using your IITJ Email ID.");
  //     return;
  //   }

  //   //try creating user
  //   try {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailTextController.text,
  //         password: passwordTextController.text);

  //     //pop loading circle
  //     if (context.mounted) Navigator.pop(context);
  //   } on FirebaseAuthException catch (e) {
  //     //pop loading circle
  //     Navigator.pop(context);
  //     //display error message
  //     displayMessage(e.code);
  //   }
  // }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 50,
                    ),

                    const Text(
                      "JTribe - Just Let It Out!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //welcome back msg
                    Text(
                      "Let's create an account for you!",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //email textfield
                    MyTextField(
                        controller: emailTextController,
                        hintText: "Email",
                        obscureText: false),
                    const SizedBox(
                      height: 10,
                    ),

                    //password  textfield
                    MyTextField(
                        controller: passwordTextController,
                        hintText: "Password",
                        obscureText: true),
                    const SizedBox(
                      height: 10,
                    ),

                    //confirm password  textfield
                    MyTextField(
                        controller: confirmpasswordTextController,
                        hintText: "Confirm Password",
                        obscureText: true),
                    const SizedBox(
                      height: 10,
                    ),

                    //send otp button
                    MyButton(
                      onTap: sendOTP,
                      text: 'Send OTP',
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // //enter otp textfield
                    MyTextField(
                        controller: otpController,
                        hintText: "Enter OTP",
                        obscureText: false),

                    const SizedBox(
                      height: 10,
                    ),

                    MyButton(
                      onTap: verifyOTP,
                      text: 'Verify OTP & Sign Up',
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    //go to register page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Login now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
