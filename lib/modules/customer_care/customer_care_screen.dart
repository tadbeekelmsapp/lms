import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/helpers.dart';

class CustomerCareScreen extends StatefulWidget {
  const CustomerCareScreen({ Key? key }) : super(key: key);

  @override
  State<CustomerCareScreen> createState() => _CustomerCareScreenState();
}

class _CustomerCareScreenState extends State<CustomerCareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Care")),
      body: Center(
        child: ElevatedButton(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Image.asset('assets/images/wa.png', width: 40)
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Contact on WhatsApp',
                  style: TextStyle(fontSize: 14)
                ),
              )
            ]
          ),
          onPressed: () {
            launchWhatsApp();
          }
        )
      )
    );
  }
}