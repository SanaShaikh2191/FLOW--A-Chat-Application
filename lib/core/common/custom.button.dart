import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final Function()? onPressed;
  const CustomButton({super.key, this.child, this.text, this.onPressed})
    : assert(
        text != null || child != null,
        'Either text or child must be provided',
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () async {
                await onPressed?.call();
              },
              
        child:
            child ??
            Text(
              text!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}
