import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CommonLoadingIndicator extends StatelessWidget {
  const CommonLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withAlpha(128),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("감정 추출 중",
              style: TextStyle(
                fontFamily: "Pretendard",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: -0.32,
                color: Colors.white,
              )),
          SizedBox(
            height: 40,
            child: LoadingIndicator(
                indicatorType: Indicator.ballPulseSync,

                /// Required, The loading type of the widget
                colors: [
                  Color(0xFFEC7C61),
                  Color(0xFFBEBADC),
                  Color(0xFF93B1F3)
                ],

                /// Optional, The color collections
                strokeWidth: 2,

                /// Optional, The stroke of the line, only applicable to widget which contains line
                backgroundColor: Colors.transparent,

                /// Optional, Background of the widget
                pathBackgroundColor: Colors.black

                /// Optional, the stroke backgroundColor
                ),
          ),
        ],
      ),
    );
  }
}
