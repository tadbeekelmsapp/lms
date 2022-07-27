import 'package:flutter/material.dart';

AppBar appBar({required String title}) {
  return AppBar(
    backgroundColor: Colors.black,
    centerTitle: true,
    title: Text(title,  
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20, 
        fontFamily: "Nasalization", 
        color: Colors.white, 
        letterSpacing: 4,
      )
    ),
  );
}

Widget squareCard({
  required String title,
  required String assetImagePath,
  var onTap
}) {
  return Container(
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      color: Color(0xff171d2a),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: GestureDetector(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          Image.asset(assetImagePath, width: 80)
        ],
      ),
      onTap: onTap,
    )
  );
}