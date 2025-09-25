import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/common/yes_or_no_dialog.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_event.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_state.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/presentation/widgets/day_detail_bottom_sheet.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:diary_mobile_client/src/feature/profile/presentation/profile_page.dart';
import 'package:diary_mobile_client/src/core/deep_link/deep_link_cubit.dart';
import 'package:diary_mobile_client/src/feature/recommend/application/recommend_bloc.dart';
import 'package:diary_mobile_client/src/feature/recommend/application/recommend_state.dart';
import 'package:diary_mobile_client/src/feature/signin/presentation/signin_page.dart';
import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../injection.dart';
import '../../application/moments/moment_list_bloc.dart' as bloc;
import '../../application/moments/moment_list_state.dart';

/// Displays a list of SampleItems.
class MomentCalendarPage extends StatefulWidget {
  const MomentCalendarPage({
    super.key,
  });

  static const routeName = '/moments-calendar';

  @override
  MomentCalendarPageState createState() => MomentCalendarPageState();
}

class MomentCalendarPageState extends State<MomentCalendarPage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    AnalyticsManager.logEvent('calendar_viewed');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<MomentCalendarBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<DeepLinkCubit, DeepLinkState>(
                listener: (context, state) {
                  if (state is LoginCallbackReceived) {
                    // 로그인 콜백 처리
                    Navigator.of(context)
                        .pushReplacementNamed(ProfilePage.routeName);
                  } else if (state is DeepLinkError) {
                    // 오류 발생 시 로그인 페이지로 이동
                    Navigator.of(context)
                        .pushReplacementNamed(SignInPage.routeName);
                  }
                },
              ),
              BlocListener<RecommendBloc, RecommendState>(
                listenWhen: (previous, current) {
                  return previous.recommendResultSet !=
                      current.recommendResultSet;
                },
                listener: (context, state) {
                  if (state.recommendResultSet.isRecommendLock) {
                    showYesOrNoDialog(
                      context,
                      title: '앱 잠금을 활성화하시겠습니까?',
                      message: '앱 잠금을 활성화하면 앱을 사용하기 전에 잠금화면이 표시됩니다.',
                      onConfirm: (bool value) {
                        context.read<LockCubit>().setLockEnabled(true);
                      },
                      yesText: '확인',
                      noText: '취소',
                    );
                  } else if (state
                      .recommendResultSet.isRecommendSendingDataToServer) {
                    showYesOrNoDialog(
                      context,
                      title: '데이터 전송을 활성화하시겠습니까?',
                      message: '데이터 전송을 활성화하여 크레파스 앱의 기능개발을 도울 수 있습니다.',
                      onConfirm: (bool value) {
                        context.read<LockCubit>().setLockEnabled(true);
                      },
                      yesText: '확인',
                      noText: '취소',
                    );
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: Colors.white,

              bottomSheet: const DayDetailBottomSheet(),

              // To work with lists that may contain a large number of items, it’s best
              // to use the ListView.builder constructor.
              //
              // In contrast to the default ListView constructor, which requires
              // building all Widgets up front, the ListView.builder constructor lazily
              // builds Widgets as they’re scrolled into view.
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CalendarHeader(
                        onTapRight: () {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        onTapLeft: () {
                          pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                      const SizedBox(height: 15),
                      Calendar(onCalendarCreated: (pageController) {
                        this.pageController = pageController;
                      }),
                    ],
                  ),
                ),
              ),
              // floatingActionButton: WriteMomentButton(
              //   onTap: () async {

              //   },
              // ),
            ),
          );
        },
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  final Function(PageController) onCalendarCreated;
  const Calendar({
    super.key,
    required this.onCalendarCreated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.MomentListBloc, MomentListState>(
      buildWhen: (previous, current) {
        return previous.moments != current.moments;
      },
      builder: (context, listState) {
        return BlocBuilder<MomentCalendarBloc, MomentCalendarState>(
          buildWhen: (previous, current) {
            return previous.selectedDay != current.selectedDay ||
                previous.calendarFormat != current.calendarFormat;
          },
          builder: (context, calendarState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  const DaysOfWeek(),
                  const SizedBox(height: 12),
                  TableCalendar(
                    // headerVisible: true,
                    // daysOfWeekVisible: true,
                    // headerStyle: const HeaderStyle(
                    //   headerMargin: EdgeInsets.only(bottom: 12),
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //   ),
                    // ),

                    onCalendarCreated: (pageController) {
                      onCalendarCreated(pageController);
                    },
                    rowHeight: 68,
                    onPageChanged: (DateTime page) {
                      context.read<MomentCalendarBloc>().add(ChangePage(page));
                      final now = DateTime.now();
                      final direction =
                          page.isAfter(DateTime(now.year, now.month))
                              ? 'next'
                              : 'previous';
                      AnalyticsManager.logEvent('calendar_page_changed',
                          parameters: {
                            'direction': direction,
                          });
                    },
                    daysOfWeekVisible: false,
                    headerVisible: false,
                    selectedDayPredicate: (day) {
                      return isSameDay(calendarState.selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      context
                          .read<MomentCalendarBloc>()
                          .add(SelectDay(selectedDay));
                      AnalyticsManager.logEvent('calendar_day_selected',
                          parameters: {
                            'day': selectedDay.toString(),
                            'focusedDay': focusedDay.toString(),
                          });
                      AnalyticsManager.logEvent(
                          'calendar_write_button_clicked');

                      final selectedDayMoments = listState.moments[selectedDay];

                      if (selectedDayMoments != null &&
                          selectedDayMoments.isNotEmpty) {
                        Navigator.of(context).pushNamed(
                            WriteMomentPage.routeName,
                            arguments: WriteMomentPageArguments(
                                moment: selectedDayMoments.first,
                                isBlendMode: true,
                                date: selectedDayMoments.first.date));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WriteMomentPage(
                                arguments: WriteMomentPageArguments(
                                    moment: null,
                                    isBlendMode: true,
                                    date: selectedDay))));
                      }
                    },
                    calendarFormat: calendarState.calendarFormat,
                    onFormatChanged: (format) {
                      // context
                      //     .read<MomentCalendarBloc>()
                      //     .add(ChangeCalendarFormat(format));
                    },
                    eventLoader: (day) {
                      return listState.moments[day] ?? [];
                    },
                    // firstDay: listState.firstDay ??
                    firstDay: DateTime(1970),
                    lastDay: DateTime(DateTime.now().year + 100),
                    focusedDay: DateTime.now(),
                    // onDaySelected: (selectedDay, focusedDay) {
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => WriteMomentPage(
                    //       arguments: WriteMomentPageArguments(
                    //           moment: null, isBlendMode: true, date: selectedDay))));
                    // },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, moments) {
                        if (moments.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 23.0),
                            child: SvgPicture.asset(
                              "assets/images/feature/moment/moment_calendar/check_marker.svg",
                              width: 14,
                              height: 12,
                            ),
                          );
                        }
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return DayArea(
                          day: day.day.toString(),
                          dayColor: const Color(0xFFEC7D61),
                          areaColor: const Color(0xFFF3E9E5),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return DayArea(
                          day: day.day.toString(),
                          dayColor: const Color(0xFF000000),
                          areaColor: const Color(0xFFF6F6F6),
                        );
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        return DayArea(
                          day: day.day.toString(),
                          dayColor: const Color(0xFF000000),
                          areaColor: const Color(0xFFF6F6F6),
                        );
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        return const DayArea(
                          day: "",
                          dayColor: Color(0xFF000000),
                          areaColor: Color(0xFFF6F6F6),
                        );
                      },
                      disabledBuilder: (context, day, focusedDay) {
                        return DayArea(
                          day: day.day.toString(),
                          dayColor: const Color(0xFF000000),
                          areaColor: const Color(0xFFF6F6F6),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DayArea extends StatelessWidget {
  final String day;
  final Color areaColor;
  final Color dayColor;
  const DayArea(
      {super.key,
      required this.day,
      required this.areaColor,
      required this.dayColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: areaColor),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            day,
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 20 / 12,
              letterSpacing: -0.3,
              color: dayColor,
            ),
          ),
        ),
      ),
    );
  }
}

class DaysOfWeek extends StatelessWidget {
  const DaysOfWeek({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...days.map((day) => Flexible(
              child: Container(
                height: 32,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF7F7F7F),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(day,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: -0.35,
                        color: Color(0xFF959490),
                      )),
                ),
              ),
            ))
      ],
    );
  }
}

class CalendarHeader extends StatelessWidget {
  final Function onTapRight;
  final Function onTapLeft;
  const CalendarHeader({
    super.key,
    required this.onTapRight,
    required this.onTapLeft,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MomentCalendarBloc, MomentCalendarState>(
      buildWhen: (previous, current) {
        return previous.selectedPage != current.selectedPage;
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 3),
              Text(
                DateFormat('yyyy').format(state.selectedPage ?? DateTime.now()),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  letterSpacing: -0.4,
                  color: Color(0xFF959490),
                ),
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => onTapLeft(),
                        child: SvgPicture.asset(
                          'assets/images/feature/moment/moment_calendar/left.svg',
                          width: 26,
                          height: 26,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        DateFormat('MMMM')
                            .format(state.selectedPage ?? DateTime.now()),
                        style: const TextStyle(
                            fontSize: 32,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: -0.8,
                            color: Color(0xFF53545B)),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => onTapRight(),
                        child: SvgPicture.asset(
                          'assets/images/feature/moment/moment_calendar/right.svg',
                          width: 26,
                          height: 26,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfilePage.routeName);
                      },
                      child: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
