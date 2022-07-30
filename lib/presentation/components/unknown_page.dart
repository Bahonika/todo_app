import 'package:flutter/material.dart';
import 'package:todo_app/s.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(S.of(context).unknownPage),
      ),
    );
  }
}
