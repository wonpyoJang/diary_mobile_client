import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 27),
        child: InkWell(
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFF956C),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Center(
                child: SvgPicture.asset(
                    "assets/images/feature/moment/write_moment/next.svg")),
          ),
        ),
      ),
    );
  }
}
