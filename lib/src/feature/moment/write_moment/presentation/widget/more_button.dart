import 'package:flutter/widgets.dart';

class MoreButton extends StatelessWidget {
  const MoreButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: SizedBox(
          child: Text(
        "more +",
        style: TextStyle(
          fontFamily: "Pretendard",
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF959490),
          height: 2,
          letterSpacing: -0.24,
        ),
      )),
    );
  }
}
