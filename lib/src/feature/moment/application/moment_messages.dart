import '../../../bus/bus_message.dart';
import '../domain/entity/moment.dart';

class MomentCreatedMessage extends BusMessage {
  final Moment moment;
  final DateTime date;
  MomentCreatedMessage({
    required this.moment,
    required this.date,
  });
}

class MomentModifiedMessage extends BusMessage {
  final Moment moment;
  final DateTime modeifiedAt;
  MomentModifiedMessage({
    required this.moment,
    required this.modeifiedAt,
  });
}

class MomentDeletedMessage extends BusMessage {
  final Moment moment;
  MomentDeletedMessage({
    required this.moment,
  });
}
