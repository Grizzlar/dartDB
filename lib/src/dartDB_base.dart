import 'dart:isolate';
import 'shell_isolate.dart';

enum op {
  INSERT,
  UPDATE,
  RETRIEVE,
  DELETE,
}

class DBServerDaemon {
  Map<int, Isolate> shellServerIsolate = {};
  Map<int, SendPort> shellServerPort = {};
  int shellIsolateCount;
  bool auth = false;
  String secret;
  int port = 2921;
  String host = '0.0.0.0';
  DBServerDaemon(this.host, this.port, [this.secret = '']) {
    if (secret != '') {
      auth = true;
    }
  }

  void initServers([int isolateCount = 1]) async {
    shellIsolateCount = isolateCount;
    for (var i=0;i<isolateCount;i++) {
      var rp = ReceivePort();
      shellServerIsolate[i] = await Isolate.spawn(shellServer, [i, host, port, rp.sendPort]);
      rp.listen((data) {
        if(data is SendPort) {
          shellServerPort[i] = data;
        }else{
          shellManager(data);
        }
      });
    }
  }

  void shellManager(Map<String, dynamic> args) {
    var serverId = args['id'];
    var data = args['data'];
    var opcode = data[0];
    if(opcode < 97 || opcode > 100) return;
    switch(op.values[opcode-97]){
      case op.INSERT: {
        print('INSERT');
      }
      break;
      case op.UPDATE: {
        print('UPDATE');
      }
      break;
      case op.RETRIEVE: {
        print('RETRIEVE');
      }
      break;
      case op.DELETE: {
        print('DELETE');
      }
      break;
    }
    shellServerPort[serverId].send('OK');
  }
}