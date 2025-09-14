import 'package:flutter/material.dart';

class DateBox extends StatelessWidget {
  final DateTime date;
  const DateBox({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final month = date.month;
    final day = date.day;

    final monthStr = month.toString().padLeft(2, '0');
    final monthFirstDigit = monthStr[0];
    final monthSecondDigit = monthStr[1];

    final dayStr = day.toString().padLeft(2, '0');
    final dayFirstDigit = dayStr[0];
    final daySecondDigit = dayStr[1];

    return SizedBox(
      width: 59,
      height: 56,
      child: Center(
        child: Text(
            "$monthFirstDigit $monthSecondDigit\n$dayFirstDigit $daySecondDigit",
            style: const TextStyle(
              color: Color(0xFF53545B),
              fontSize: 28,
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: -0.24,
              fontFamily: "SpoqaHanSansNeo",
            )),
      ),
    );
  }
}
