import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_state.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_state.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

showDayDetailBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (context) => const DayDetailBottomSheet(),
  );
}

class DayDetailBottomSheet extends StatefulWidget {
  
  const DayDetailBottomSheet({super.key});

  @override
  State<DayDetailBottomSheet> createState() => _DayDetailBottomSheetState();
}

class _DayDetailBottomSheetState extends State<DayDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      snap: true,
      initialChildSize: 0.15,
      minChildSize: 0.15, // 최소 닫힘 높이
      maxChildSize: 0.9, // 최대 열림 높이
      shouldCloseOnMinExtent: false,
      expand: false,
      builder: (context, scrollController) {
        return BlocBuilder<MomentListBloc, MomentListState>(
          builder: (context, listState) {
            return BlocBuilder<MomentCalendarBloc, MomentCalendarState>(
              builder: (context, calendarState) {
                final item = listState.moments
                        .containsKey(calendarState.selectedDay)
                    ? listState.moments[calendarState.selectedDay]?.firstOrNull
                    : null;

                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 500,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(52, 149, 148, 144),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: Offset(0, -4), // changes position of shadow
                          ),
                        ],
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(26, 128, 128, 128),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Handle(),
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 2.0, bottom: 0),
                                child: Text(
                                  DateFormat('MMMM d, yyyy')
                                      .format(calendarState.selectedDay!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 20 / 16,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (item != null)
                            EmotionList(
                              emotionalIntensies: item.emotionalIntensities,
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                        ],
                      )
                      // child: ListView.builder(
                      //   controller: scrollController,
                      //   physics: const ClampingScrollPhysics(),
                      //   restorationId: 'sampleItemListView',
                      //   itemCount:
                      //       (listState.moments[calendarState.selectedDay]?.length ??
                      //               0) +
                      //           2,
                      //   itemBuilder: (context, index) {
                      //     final lastIndex = (listState
                      //                 .moments[calendarState.selectedDay]?.length ??
                      //             0) +
                      //         1;

                      //     if (index == 0) {
                      //       return Column(
                      //         children: [
                      //           const Handle(),
                      //           SizedBox(
                      //             width: double.infinity,
                      //             child: Center(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(
                      //                     top: 2.0, bottom: 31),
                      //                 child: Text(
                      //                   DateFormat('MMMM d, yyyy')
                      //                       .format(calendarState.selectedDay!),
                      //                   style: const TextStyle(
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.w600,
                      //                     height: 20 / 16,
                      //                     letterSpacing: -0.4,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           )
                      //         ],
                      //       );
                      //     } else if (index == lastIndex) {
                      //       return Padding(
                      //         padding: const EdgeInsets.all(16.0),
                      //         child: ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //               builder: (context) => WriteMomentPage(
                      //                 arguments: WriteMomentPageArguments(
                      //                   moment: null,
                      //                   isBlendMode: true,
                      //                   date: calendarState.selectedDay!,
                      //                 ),
                      //               ),
                      //             ));
                      //             AnalyticsManager.logEvent(
                      //                 'day_detail_write_button_clicked');
                      //           },
                      //           child: const Text('일기 추가하기'),
                      //         ),
                      //       );
                      //     }

                      //     final item = listState
                      //         .moments[calendarState.selectedDay]![index - 1];

                      //     return MomentCard(
                      //       item: item,
                      //       onTap: () {
                      //         Navigator.of(context).pushNamed(
                      //             WriteMomentPage.routeName,
                      //             arguments: WriteMomentPageArguments(
                      //                 moment: item,
                      //                 isBlendMode: true,
                      //                 date: item.date));
                      //       },
                      //     );
                      //   },
                      // ),
                      ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class Handle extends StatelessWidget {
  const Handle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ],
        ));
  }
}
