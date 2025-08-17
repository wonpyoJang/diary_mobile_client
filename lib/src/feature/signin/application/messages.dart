import '../../../bus/bus_message.dart';

class SignInSuccessMessage extends BusMessage {
  SignInSuccessMessage();
}

class SignInFailureMessage extends BusMessage {
  final String message;
  SignInFailureMessage({
    required this.message,
  });
}
