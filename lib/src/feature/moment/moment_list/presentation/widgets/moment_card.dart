import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../application/moments/moment_list_bloc.dart';
import '../../../application/moments/moment_list_event.dart';
import '../../../domain/entity/moment.dart';

class MomentCard extends StatelessWidget {
  const MomentCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final Moment item;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
      key: ValueKey(item.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          context.read<MomentListBloc>().add(DeleteMoment(item));
        }),
        children: [
          SlidableAction(
            onPressed: (context) {
              context.read<MomentListBloc>().add(DeleteMoment(item));
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16.0), // 카드 간격 설정
        elevation: 4, // 그림자 효과 추가
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0), // 내부 여백 추가
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(25), // 새로운 배경색
                  borderRadius: BorderRadius.circular(12.0), // 더 둥근 모서리
                  border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1.5), // 테두리 색상 변경
                ),
                padding: const EdgeInsets.all(10.0), // 내부 여백 추가
                child: Text(
                  item.reflection,
                  maxLines: 3, // 최대 줄 수 증가
                  overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 처리
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface), // 글자 스타일 변경
                ),
              ),
              const SizedBox(height: 6), // 간격 추가
              Text(
                '날짜: ${item.getFormattedDateTime()}', // 현재 날짜와 시간 표시
                style:
                    theme.primaryTextTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 6), // 간격 추가
              Wrap(
                spacing: 6.0, // 감정 아이콘 간격
                children: item.emotionalIntensities.map((emotionalIntensity) {
                  return Chip(
                    label: Text(emotionalIntensity.emotion.koName),
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? emotionalIntensity.emotion.color.withAlpha(128)
                            : emotionalIntensity.emotion.color, // 감정 색상
                    labelStyle: TextStyle(
                        fontSize: 12,
                        color: emotionalIntensity.emotion.color
                                    .computeLuminance() >
                                0.5
                            ? Colors.black
                            : Colors.white), // 라벨 스타일
                  );
                }).toList(),
              ),
            ],
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}
