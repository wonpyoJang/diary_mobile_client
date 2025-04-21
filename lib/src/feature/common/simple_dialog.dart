import 'package:flutter/material.dart';

Future<dynamic> showSimpleDialog(BuildContext context,
    {required String title,
    String? message,
    Function(bool)? onConfirm,
    String? confirmText}) {
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
        child: SizedBox(
          width: 272,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    color: Color(0xFF808080),
                    fontFamily: "Pretendard",
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.32,
                  )),
              const SizedBox(height: 16),
              if (message?.isNotEmpty ?? false) ...[
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
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      onConfirm?.call(true);
                    },
                    child: Container(
                      height: 36,
                      width: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF956C),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(confirmText ?? "예",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 16,
                                    fontFamily: "SpoqaHanSansNeo",
                                    letterSpacing: -0.32,
                                    color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
