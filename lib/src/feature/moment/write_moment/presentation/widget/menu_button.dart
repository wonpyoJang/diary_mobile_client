import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Function onTap;
  const MenuButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFFF3E9E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 2,
            children: [
              ...[1, 2, 3].map((e) => Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF956C),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ))
            ],
          ))),
    );
  }
}
