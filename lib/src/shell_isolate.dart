import 'dart:io';
import 'dart:isolate';

Isolate shell;

void shellServer(List<dynamic> data) async {

  var id = data[0];
  var host = data[1];
  var port = data[2];
  var sendPort = data[3];

  var rp = ReceivePort();
  sendPort.send(rp.sendPort);
  rp.listen((message) {
    print(message);
  });

  var server = await ServerSocket.bind(host, port, shared: true);
  server.listen((socket) {
    socket.listen((data) {
      sendPort.send({'id': id, 'data': data});
    });
  });
}