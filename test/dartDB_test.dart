import 'package:dartDB/dartDB.dart';

void main() async {
  var d = DBServerDaemon('127.0.0.1', 2929);
  d.initServers(5);
}
