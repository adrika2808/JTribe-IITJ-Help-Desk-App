import "package:flutter/material.dart";

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //section name
              Text(
                sectionName,
                style: TextStyle(color: const Color.fromARGB(255, 70, 68, 68)),
              ),

              //edit button
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey[400],
                  )),
            ],
          ),

          //text
          Text(text),
        ],
      ),
    );
  }
}
