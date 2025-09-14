import 'dart:async';

import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/application/messages.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/entities/recommend_target_result_set.dart';
import 'package:diary_mobile_client/src/feature/recommend/domain/repositories/interfaces/i_recommend_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'recommend_event.dart';
import 'recommend_state.dart';

@injectable
class RecommendBloc extends HydratedBloc<RecommendEvent, RecommendState> {
  final Bus bus;
  final IRecommendRepository recommendRepository;
  late StreamSubscription<BusMessage> busSubscription;

  RecommendBloc(this.bus, this.recommendRepository)
      : super(const RecommendState()) {
    busSubscription = bus.subscribe((message) {
      if (message is EmotionAnalysisResultDismissed) {
        add(const TriggerRecommend());
      }
    });

    on<RecommendEvent>((event, emit) async {
      final result = await recommendRepository.getRecommendStatus();
      emit(result.fold((failure) => state.copyWith(), (recommendStatus) {
        final bool isUnlockedTarget =
            state.recommendTargetSet?.isLocked == false;
        final bool isOffSendingDataToServerTarget =
            state.recommendTargetSet?.isSendingDataToServer == false;
        final bool isRecommendLock =
            (state.recommendCount == null || state.recommendCount == 0) &&
                isUnlockedTarget;
        final bool isRecommendSendingDataToServer =
            (state.recommendCount == 1) && isOffSendingDataToServerTarget;

        final recommendResultSet = RecommendTargetResultSet(
          isRecommendSendingDataToServer: isRecommendSendingDataToServer,
          isRecommendLock: isRecommendLock,
        );

        final int nextRecommendCount = (state.recommendCount ?? 0) + 1;
        final DateTime? nextLastRecommendDate =
            recommendResultSet.isAnythingRecommend
                ? DateTime.now()
                : state.lastRecommendDate;

        return state.copyWith(
          recommendCount: nextRecommendCount,
          lastRecommendDate: nextLastRecommendDate,
          recommendTargetSet: recommendStatus,
          recommendResultSet: recommendResultSet,
        );
      }));
    });
  }

  @override
  RecommendState? fromJson(Map<String, dynamic> json) {
    return RecommendState(
      lastRecommendDate: json['lastRecommendDate'] as DateTime?,
      recommendCount: json['recommendCount'] as int?,
    );
  }

  @override
  Map<String, dynamic>? toJson(RecommendState state) {
    return {
      'lastRecommendDate': state.lastRecommendDate,
      'recommendCount': state.recommendCount,
    };
  }
}
