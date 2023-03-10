import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  String title;
  CheckboxController controller;
  
  CustomCheckbox({Key? key, required this.title, required this.controller}) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title),
        Checkbox(
          value: widget.controller.isChecked,
          onChanged: (bool? value) {
            setState(() {
              widget.controller.setValue(value!);
            });
          },
        )
      ],
    );
  }
}

class CheckboxController extends ChangeNotifier {
  bool isChecked = true;
  
  void setValue(bool value) {
    isChecked = value;
    notifyListeners();
  }
}