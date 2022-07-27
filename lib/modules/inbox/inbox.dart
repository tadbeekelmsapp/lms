import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({ Key? key }) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Your messages will show up here')
      )
    );
  }
}