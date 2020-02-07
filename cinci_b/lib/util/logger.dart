import 'package:intl/intl.dart';

class Logger {

  final String className;

  Logger(this.className);

  void debug(String message){
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('yyyy:mm:dd kk:mm:ss').format(now);
    print("DEBUG: [$formattedTime] [$className] - $message");
  }

  void error(String message){
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('yyyy:mm:dd kk:mm:ss').format(now);
    print("ERROR: [$formattedTime] [$className] - $message");
  }

}