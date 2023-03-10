import 'package:flutter/material.dart';

class CustomCounter extends StatefulWidget {
  String title;
  CounterController controller;
  
  CustomCounter({Key? key, required this.title, required this.controller}) : super(key: key);

  @override
  CustomCounterState createState() => CustomCounterState();
}

class CustomCounterState extends State<CustomCounter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title),
        ElevatedButton(
          child: Text(widget.controller.length.toString()),
          onPressed: () => setState(() { widget.controller.addOne(); }),
        )
      ],
    );
  }
}

class CounterController extends ChangeNotifier {
  int length = 1;
  
  void addOne() {
    length++;
    notifyListeners();
  }
}