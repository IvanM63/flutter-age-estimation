import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final IconData? icon;
  final Function()? onPressed;
  final TextEditingController? controller;

  const MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          onTap: onPressed,
          readOnly: onPressed != null ? true : false,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              suffixIcon: icon != null ? Icon(icon) : null,
              suffixIconColor: MaterialStateColor.resolveWith((states) =>
                  states.contains(MaterialState.focused)
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey),
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: onPressed == null ? Colors.grey : Colors.black),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10))),
        )
      ],
    );
  }
}
