// ignore: file_names
import 'dart:async';

import 'package:uhf_c72_plugin/tag_epc.dart';
import 'package:uhf_c72_plugin/uhf_c72_plugin.dart';

class RFIDReader {
  bool? isConnected = false;
  bool? started;
  bool? isStopped;
  List<TagEpc> tags = [];
  StreamController<List<String>> tagsStream = StreamController<List<String>>();
  Set<String> setEpcs = {};

  void connect() async {
    UhfC72Plugin.connectedStatusStream
        .receiveBroadcastStream()
        .listen(updateIsConnected);
    UhfC72Plugin.tagsStatusStream.receiveBroadcastStream().listen(updateTags);

    bool? _isConnected = await UhfC72Plugin.connect;

    if (_isConnected!) {
      await UhfC72Plugin.setWorkArea('2');
      await UhfC72Plugin.setPowerLevel('30');
    }
  }

  Stream<dynamic> stream() {
    return UhfC72Plugin.tagsStatusStream.receiveBroadcastStream();
  }

  void updateIsConnected(connection) async {
    isConnected = await UhfC72Plugin.isConnected;
    print(isConnected);
  }

  void updateTags(dynamic result) {
    tags = TagEpc.parseTags(result);

    setEpcs.addAll(tags.map((e) => e.epc.substring(4)).toList());

    tagsStream.add(setEpcs.toList());

    clearData();
  }

  void clearAll() {
    setEpcs.clear();
    clearData();
  }

  void startReading() async {
    started = await UhfC72Plugin.startContinuous;
  }

  void stopReading() async {
    isStopped = await UhfC72Plugin.stop;
  }

  void close() async {
    await UhfC72Plugin.clearData;
    await UhfC72Plugin.stop;
    await UhfC72Plugin.close;
  }

  void clearData() async {
    await UhfC72Plugin.clearData;
    tags.clear();
    tagsStream.add(setEpcs.toList());
  }

  void deleteTag(String epc) {
    //tags.removeAt(index);
    setEpcs.remove(epc);
    tagsStream.add(setEpcs.toList());
  }
}
