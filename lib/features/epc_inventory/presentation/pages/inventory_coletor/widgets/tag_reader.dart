import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meuestoque_protheus/core/themes/app_colors.dart';

import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/widgets/RFID_controller.dart';

class TagReader extends StatefulWidget {
  const TagReader({
    Key? key,
    required this.onRead,
  }) : super(key: key);
  final ValueChanged<List<String>> onRead;

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
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isStarted ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        rfidController.startReading();
                        setState(() {
                          _isStarted = true;
                        });
                      },
                      icon: const Icon(
                        Icons.play_circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: !_isStarted ? Colors.red : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        rfidController.stopReading();
                        setState(() {
                          _isStarted = false;
                        });
                      },
                      icon: const Icon(
                        Icons.stop,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: rfidController.clearAll,
                      icon: const Icon(
                        Icons.delete_forever,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
                stream: rfidController.tagsStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    widget.onRead(snapshot.data!);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Etiquetas Lidas",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                snapshot.data!.length.toString(),
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(snapshot.data![index]);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.secondary),
                              ),
                              child: Container(
                                height: 50,
                                child: const Center(child: Text("Confirmar")),
                              ),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: Text("Nenhuma etiqueta."),
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
