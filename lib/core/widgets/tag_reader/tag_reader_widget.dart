import 'package:audioplayers/audioplayers.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../features/epc_inventory/model/epc_inventory_model.dart';
import '../../../objectbox.g.dart';
import '../../constants.dart';
import '../../database/db.dart';
import 'data/local_tags_repository.dart';
import 'model/tags_model.dart';
import 'widgets/tag_tile_widget.dart';

class TagReader extends StatefulWidget {
  const TagReader({Key? key}) : super(key: key);
  @override
  State<TagReader> createState() => _TagReaderState();
}

class _TagReaderState extends State<TagReader> {
  final LocalTagsRepository localTagsRepository = LocalTagsRepository();
  final player = AudioCache();
  Box<EpcInventory> box = Db.store!.box<EpcInventory>();

  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "data.rfid",
      "data.barcode",
    ],
  );

  void successSound() {
    player.play('beep.mp3');
  }

  void onRead(BroadcastMessage message) {
    print(message);

    if (message.data!["SCAN_STATE"] == "success") {
      if (message.name == "data.rfid") {
        final Tags tag = Tags(
          data: message.data!["data"],
          epc: message.data!["data"],
          barcode: "",
          codeType: "RFID",
          rssi: message.data!["rssi"],
        );

        if (localTagsRepository.add(tag)) successSound();
      }

      if (message.name == "data.barcode") {
        final Tags tag = Tags(
          data: message.data!["data"],
          epc: "",
          barcode: message.data!["data"],
          codeType: message.data!["CODE_TYPE"],
          rssi: "",
        );

        if (localTagsRepository.add(tag)) successSound();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    receiver.start();
    receiver.messages.listen(onRead);
  }

  @override
  void dispose() {
    receiver.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          centerTitle: true,
          title: const Text('Coletor de Etiquetas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await LaunchApp.openApp(
                  androidPackageName: 'com.rscja.scanner',
                  // openStore: false
                );
                // handle the press
              },
            ),
          ],
        ),
        body: StreamBuilder<List<Tags>>(
          stream: localTagsRepository.streamTags,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var etiqs = snapshot.data!;

            etiqs.sort((a, b) => b.id.compareTo(a.id));

            return Column(
              children: [
                FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Etiquetas: ${etiqs.length}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.00),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: etiqs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TagListTile(
                        tag: etiqs[index],
                        onLongPress: () {
                          deleteOne(etiqs[index]);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text("Deletar Todos"),
                              SizedBox(
                                width: 10,
                              ),
                              FaIcon(FontAwesomeIcons.trash),
                            ],
                          ),
                          onPressed: deleteAll,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text("Salvar"),
                              SizedBox(
                                width: 10,
                              ),
                              FaIcon(FontAwesomeIcons.save),
                            ],
                          ),
                          onPressed: saveAll,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void deleteAll() async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Confirma deletar todas as etiquetas?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Deletar'),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (result != null) {
      if (result.contains('Deletar')) {
        localTagsRepository.deleteAll();
      }
    }
  }

  void deleteOne(Tags tag) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmação'),
        content: Text('Confirma deletar a etiqueta ${tag.data} ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Deletar'),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (result != null) {
      if (result.contains('Deletar')) {
        localTagsRepository.deleteTag(tag);
      }
    }
  }

  void saveAll() {
    final tags = localTagsRepository.getAllTagsToString();
    Navigator.of(context).pop(tags.toList());
  }
}

/* 
   


*/