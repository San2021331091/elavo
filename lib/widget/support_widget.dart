import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldfieldTextStyle({Color color = Colors.green,double fontSize = 25.0}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle lightfieldTextStyle({Color color = const Color.fromARGB(255, 120, 12, 52), double fontSize = 17.0}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}


class AppColors {
  static const Color primary = Color.fromARGB(255, 218, 89, 3);
  static const Color secondary = Color.fromARGB(255, 211, 6, 6);
  
  
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final int maxLines;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Use the controller passed from parent OR create a new one
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Only dispose if it was created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controller, // ✅ make sure controller is here
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
      ),
    );
  }

  String get text => _controller.text;
}


