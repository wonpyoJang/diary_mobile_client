import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/application/moments/moment_list_state.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_state.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_list/presentation/widgets/moment_card.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryListBottomSheet extends StatelessWidget {
  const DiaryListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5, // 절반 높이로 시작
      minChildSize: 0.2, // 최소 닫힘 높이
      maxChildSize: 0.9, // 최대 열림 높이
      expand: false,
      builder: (context, scrollController) {
        return BlocBuilder<MomentListBloc, MomentListState>(
          builder: (context, listState) {
            return BlocBuilder<MomentCalendarBloc, MomentCalendarState>(
              builder: (context, calendarState) {
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                    controller: scrollController,
                    restorationId: 'sampleItemListView',
                    itemCount:
                        (listState.moments[calendarState.selectedDay]?.length ??
                                0) +
                            1,
                    itemBuilder: (context, index) {
                      final lastIndex = (listState
                              .moments[calendarState.selectedDay]?.length ??
                          0);
                      if (index == lastIndex) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WriteMomentPage(
                                  arguments: WriteMomentPageArguments(
                                    moment: null,
                                    isBlendMode: true,
                                    date: calendarState.selectedDay!,
                                  ),
                                ),
                              ));
                            },
                            child: const Text('일기 추가하기'),
                          ),
                        );
                      }

                      final item =
                          listState.moments[calendarState.selectedDay]![index];

                      return MomentCard(
                        item: item,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              WriteMomentPage.routeName,
                              arguments: WriteMomentPageArguments(
                                  moment: item,
                                  isBlendMode: true,
                                  date: item.date));
                        },
                      );
                    },
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
