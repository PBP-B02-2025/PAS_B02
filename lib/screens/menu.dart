import 'package:flutter/material.dart';
import '../review/review_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ballistic Home'),
        ),
        body: Center(
          child: Row(
            children: [
              Text('Welcome to Ballistic!'),
              InkWell(
                onTap: () {
                  print('Text tapped!');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Review()),
                  );
                },
                child: Text('Tap me!'),
              )
            ],
          )
        ),
      );
  }
}