import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uhf_c72_plugin/tag_epc.dart';
import 'package:uhf_c72_plugin/uhf_c72_plugin.dart';

class TagReader extends StatefulWidget {
  const TagReader({Key? key}) : super(key: key);

  @override
  State<TagReader> createState() => _TagReaderState();
}

class _TagReaderState extends State<TagReader> {
  String _platformVersion = 'Unknown';
  bool _isStarted = false;
  bool _isStopped = false;
  bool? _isConnected = false;
  List<TagEpc> _data = [];
  String potency = "Máxima (30)";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: keyPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: startReading,
                  color: _isStarted ? Colors.green : Colors.grey,
                  icon: const Icon(
                    Icons.play_circle,
                  ),
                ),
                IconButton(
                  onPressed: stopReading,
                  color: _isStopped ? Colors.red : Colors.grey,
                  icon: const Icon(
                    Icons.stop,
                  ),
                ),
                const Text("Tags Lidas"),
                Text("${_data.length}")
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Potencia: $potency"),
              IconButton(
                onPressed: () async {
                  await UhfC72Plugin.setPowerLevel('30');
                  stopReading();
                  clearData();
                  setState(() {
                    potency = "Máxima (30)";
                  });
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await UhfC72Plugin.setPowerLevel('15');
                  stopReading();
                  clearData();
                  setState(() {
                    potency = "Mínima (15)";
                  });
                },
                icon: const Icon(
                  Icons.remove,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_data[index].epc.substring(4)),
                    visualDensity: VisualDensity.compact,
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "RRSI:  ${_data[index].rssi}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text("Contagem: ${_data[index].count}",
                            style: const TextStyle(color: Colors.white))
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      onPressed: clearData,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  void keyPressed(RawKeyEvent key) {
    RawKeyEventDataAndroid keyCode = key.data as RawKeyEventDataAndroid;
    if (keyCode.keyCode == 293 || keyCode.keyCode == 139) {
      if (key.isKeyPressed(key.logicalKey)) {
        startReading();
      } else {
        stopReading();
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await UhfC72Plugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    UhfC72Plugin.connectedStatusStream
        .receiveBroadcastStream()
        .listen(updateIsConnected);
    UhfC72Plugin.tagsStatusStream.receiveBroadcastStream().listen(updateTags);

    _isConnected = await UhfC72Plugin.connect;

    if (_isConnected!) {
      await UhfC72Plugin.setWorkArea('2');
      await UhfC72Plugin.setPowerLevel('30');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion!;
    });
  }

  void updateIsConnected(isConnected) async {
    bool? isConnected = await UhfC72Plugin.isConnected;
    log('connected $isConnected');
    _isConnected = isConnected!;
  }

  void updateTags(dynamic result) {
    //log('update tags');
    setState(() {
      _data = TagEpc.parseTags(result);
    });
  }

  void startReading() async {
    bool? started = await UhfC72Plugin.startContinuous;

    setState(() {
      _isStarted = started!;
      _isStopped = false;
    });

    log('Start Continuous $_isStarted');
  }

  void startSingleReading() async {
    bool? isStarted = await UhfC72Plugin.startSingle;
    log('Start signle $isStarted');
  }

  void stopReading() async {
    bool? isStopped = await UhfC72Plugin.stop;

    setState(() {
      _isStarted = false;
      _isStopped = isStopped!;
    });

    log('Stop $_isStopped');
  }

  void close() async {
    await UhfC72Plugin.clearData;
    await UhfC72Plugin.stop;
    await UhfC72Plugin.close;
  }

  void clearData() async {
    await UhfC72Plugin.clearData;
    setState(() {
      _data = [];
    });
  }
}
