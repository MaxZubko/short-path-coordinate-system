import 'package:flutter/material.dart';

class DefaultButton extends StatefulWidget {
  final String title;
  final bool isDisable;
  final Function() onPressed;
  const DefaultButton({
    super.key,
    required this.title,
    this.isDisable = false,
    required this.onPressed,
  });

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isDisable) {
          widget.onPressed();
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: widget.isDisable ? Colors.grey : Colors.blue.shade300,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.isDisable ? Colors.grey : Colors.blue,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
