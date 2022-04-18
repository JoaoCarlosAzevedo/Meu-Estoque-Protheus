import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/widgets/RFID_controller.dart';
import 'package:uhf_c72_plugin/tag_epc.dart';
import 'package:uhf_c72_plugin/uhf_c72_plugin.dart';

class TagReader extends StatefulWidget {
  const TagReader({Key? key}) : super(key: key);

  @override
  State<TagReader> createState() => _TagReaderState();
}

class _TagReaderState extends State<TagReader> {
  RFIDReader rfidController = RFIDReader();
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    rfidController.connect();
  }

  @override
  void dispose() {
    rfidController.close();
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
                  onPressed: rfidController.startReading,
                  color: _isStarted ? Colors.green : Colors.grey,
                  icon: const Icon(
                    Icons.play_circle,
                  ),
                ),
                IconButton(
                  onPressed: rfidController.stopReading,
                  color: !_isStarted ? Colors.red : Colors.grey,
                  icon: const Icon(
                    Icons.stop,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TagEpc>>(
                stream: rfidController.tagsStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text("Etiquetas Lidas: ${rfidController.tags.length}"),
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                      snapshot.data![index].epc.substring(4)),
                                  visualDensity: VisualDensity.compact,
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "RRSI:  ${snapshot.data![index].rssi}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                          "Contagem: ${snapshot.data![index].count}",
                                          style: const TextStyle(
                                              color: Colors.white))
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        rfidController.deleteTag(index),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: Text("Stream Vazia"),
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
        rfidController.startReading();
        setState(() {
          _isStarted = true;
        });
      } else {
        rfidController.stopReading();
        setState(() {
          _isStarted = false;
        });
      }
    }
  }
}
