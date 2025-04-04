import 'package:flutter/material.dart';

Future<dynamic> showYesOrNoDialog(BuildContext context,
    {required String title,
    String? message,
    Function(bool)? onConfirm,
    String? yesText,
    String? noText}) {
  return showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  color: Color(0xFF4D4E58),
                  fontFamily: "SpoqaHanSansNeo",
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: -0.4,
                )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(message ?? "",
                          style: const TextStyle(
                              color: Color(0xFF4D4E58),
                              fontFamily: "SpoqaHanSansNeo",
                              fontSize: 16,
                              letterSpacing: 0.32)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFADCBFF),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(noText ?? "아니오",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 16,
                                    fontFamily: "SpoqaHanSansNeo",
                                    letterSpacing: -0.32,
                                    color: const Color(0xFF4D4E58))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      onConfirm?.call(true);
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFADCBFF),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(yesText ?? "예",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 16,
                                    fontFamily: "SpoqaHanSansNeo",
                                    letterSpacing: -0.32,
                                    color: const Color(0xFF4D4E58))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
