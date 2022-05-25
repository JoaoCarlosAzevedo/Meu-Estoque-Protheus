import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/themes/app_colors.dart';

import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/widgets/RFID_controller.dart';

class TagReaderv2 extends StatefulWidget {
  const TagReaderv2({
    Key? key,
    required this.onRead,
  }) : super(key: key);
  final ValueChanged<List<String>> onRead;

  @override
  State<TagReaderv2> createState() => _TagReaderState();
}

class _TagReaderState extends State<TagReaderv2> {
  RFIDReader rfidController = RFIDReader();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    rfidController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitura de Etiquetas"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: secondaryColor,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<bool>(
        future: rfidController
            .connect(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return RFIDReaderPage(
                rfidController: rfidController, widget: widget);
          } else if (snapshot.hasError) {
            return const Text("Erro ao carregar leitor RIFD");
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Carregando leitor...'),
                  )
                ],
              ),
            );
          }
          //return const Text("Erro desconhecido!");
        },
      ),
    );

    //
  }
}

class RFIDReaderPage extends StatefulWidget {
  const RFIDReaderPage({
    Key? key,
    required this.rfidController,
    required this.widget,
  }) : super(key: key);

  final RFIDReader rfidController;
  final TagReaderv2 widget;

  @override
  State<RFIDReaderPage> createState() => _RFIDReaderPageState();
}

class _RFIDReaderPageState extends State<RFIDReaderPage> {
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RawKeyboardListener(
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
                          if (!_isStarted) {
                            widget.rfidController.startReading();
                            setState(() {
                              _isStarted = true;
                            });
                          }
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
                          widget.rfidController.stopReading();
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
                        onPressed: widget.rfidController.clearAll,
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
                  stream: widget.rfidController.tagsStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      widget.widget.onRead(snapshot.data!);
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
                                onPressed: () {
                                  Navigator.of(context).pop(snapshot.data!);
                                },
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
      ),
    );
  }

  void keyPressed(RawKeyEvent key) {
    RawKeyEventDataAndroid keyCode = key.data as RawKeyEventDataAndroid;
    if (keyCode.keyCode == 293 || keyCode.keyCode == 139) {
      if (key.isKeyPressed(key.logicalKey)) {
        if (!_isStarted) {
          widget.rfidController.startReading();
          setState(() {
            _isStarted = true;
          });
        }
      } else {
        widget.rfidController.stopReading();
        setState(() {
          _isStarted = false;
        });
      }
    }
  }
}
