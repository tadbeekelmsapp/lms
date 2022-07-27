import 'package:flutter/material.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({ Key? key }) : super(key: key);

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),
      body: const Center(child: Text('Your purchases will show up here'),)
    );
  }
}