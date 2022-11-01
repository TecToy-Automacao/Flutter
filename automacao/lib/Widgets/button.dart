import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final double text_size;
  final Color text_color;
  final Color background;
  final Function onTap;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.text_size,
    required this.text_color,
    required this.background,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width / 1.1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: this.background,
        ),
        child: Text(
          this.text.toUpperCase(),
          style: TextStyle(
            fontSize: this.text_size,
            color: this.text_color,
          ),
        ),
        onPressed: () {
          this.onTap;
        },
      ),
    );
  }
}
