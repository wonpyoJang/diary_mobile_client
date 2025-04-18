import 'package:diary_mobile_client/src/core/analytics/analytics_manager.dart';
import 'package:diary_mobile_client/src/feature/moment/domain/entity/moment.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_bloc.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_event.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/application/moment_calendar_state.dart';
import 'package:diary_mobile_client/src/feature/moment/moment_calendar/presentation/widgets/day_detail_bottom_sheet.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../injection.dart';
import '../../application/moments/moment_list_bloc.dart' as bloc;
import '../../application/moments/moment_list_state.dart';
import '../../presentation/widgets/write_moment_button.dart';

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
    final deviceWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<MomentCalendarBloc>(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,

          bottomSheet: const DayDetailBottomSheet(),

          // To work with lists that may contain a large number of items, it’s best
          // to use the ListView.builder constructor.
          //
          // In contrast to the default ListView constructor, which requires
          // building all Widgets up front, the ListView.builder constructor lazily
          // builds Widgets as they’re scrolled into view.
          body: SafeArea(
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
                const SizedBox(height: 21),
                Calendar(onCalendarCreated: (pageController) {
                  this.pageController = pageController;
                }),
              ],
            ),
          ),
          floatingActionButton: WriteMomentButton(
            onTap: () async {
              AnalyticsManager.logEvent('calendar_write_button_clicked');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WriteMomentPage(
                      arguments: WriteMomentPageArguments(
                          moment: null,
                          isBlendMode: true,
                          date: DateTime.now()))));
            },
          ),
        );
      }),
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
      builder: (context, listState) {
        return BlocBuilder<MomentCalendarBloc, MomentCalendarState>(
          buildWhen: (previous, current) {
            return previous.selectedDay != current.selectedDay ||
                previous.calendarFormat != current.calendarFormat;
          },
          builder: (context, calendarState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: TableCalendar(
                onCalendarCreated: (pageController) {
                  onCalendarCreated(pageController);
                },
                rowHeight: 65,
                onPageChanged: (DateTime page) {
                  context.read<MomentCalendarBloc>().add(ChangePage(page));
                  final now = DateTime.now();
                  final direction = page.isAfter(DateTime(now.year, now.month))
                      ? 'next'
                      : 'previous';
                  AnalyticsManager.logEvent('calendar_page_changed',
                      parameters: {
                        'direction': direction,
                      });
                },
                daysOfWeekHeight: 27,
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) =>
                      DateFormat.E(locale).format(date).toUpperCase(),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE7E7E7),
                        width: 1.0,
                      ),
                    ),
                  ),
                  weekdayStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.35,
                    color: Color(0xFF959490),
                  ),
                  weekendStyle: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.35,
                    color: Color(0xFFFF7D71),
                  ),
                ),
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
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now(),
                focusedDay: calendarState.selectedDay ?? DateTime.now(),
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
                    }

                    final firstMoment = (moments as List<Moment>).first;

                    final firstEmotionColor = firstMoment
                            .emotionalIntensities.isNotEmpty
                        ? firstMoment.emotionalIntensities.first.emotion.color
                        : Colors.grey;
                    return Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: firstEmotionColor,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    return Container(
                      color: Colors.white,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 10),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 20 / 12,
                              letterSpacing: -0.3,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return Container(
                      color: Colors.white,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 10),
                          child: Text(
                            day.day.toString(),
                            style: const TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 20 / 12,
                              letterSpacing: -0.3,
                              color: Color(0x33000000),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
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
            ],
          ),
        );
      },
    );
  }
}
