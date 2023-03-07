import 'package:flutter/material.dart';
import 'dart:convert';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('''3-3-8: Consider the following code segment where a range of “High”, “Middle”, or “Low” is being determined where x is an int and a “High” is 80 and above, a “Middle” is between 50 - 79, and “Low” is below 50.

if (x >= 80)
{
   System.out.println("High");
}

if (x >= 50)
{
  System.out.println("Middle");
}
else
{
   System.out.println("Low");
}
Which of the following initializations for x will demonstrate that the code segment will not work as intended?

A. 80
B. 60
C. 50
D. 30
E. -10'''),
        ),
      ),
    );
  }
}
