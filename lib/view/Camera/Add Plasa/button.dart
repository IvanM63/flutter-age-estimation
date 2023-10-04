import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Function()? onPressed;
  final Color? color;

  MyButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primaryContainer),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          backgroundColor: color == null
              ? MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
              : MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
        icon: Icon(icon),
        label: Text(label,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)));
  }
}
