import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meuestoque_protheus/core/themes/app_colors.dart';
import 'package:meuestoque_protheus/features/factory_inventory/data/local_factory_repository.dart';

import '../../../model/factory_tag_model.dart';

class FactoryInventoryPage extends StatefulWidget {
  const FactoryInventoryPage({Key? key}) : super(key: key);

  @override
  State<FactoryInventoryPage> createState() => _FactoryInventoryPageState();
}

class _FactoryInventoryPageState extends State<FactoryInventoryPage> {
  final LocalFactoryRepository repository = LocalFactoryRepository();
  final RegExp regex =
      RegExp(r"^(\+0?1\s)?\(?\d{6}\)?[\s.\s\d]{4}[\s.,]\d{2}$");

  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "data.rfid",
      "data.barcode",
    ],
  );

  void onRead(BroadcastMessage message) {
    if (message.data!["SCAN_STATE"] == "success") {
      // ^(\+0?1\s)?\(?\d{6}\)?[\s.\s\d]{4}[\s.,]\d{2}$
      if (message.name == "data.barcode") {
        addTag(message.data!["data"]);
      }
    }
  }

  void addTag(String data) {
    if (regex.hasMatch(data)) {
      final productCode = data.toString().substring(0, 6);
      final quantity = data.toString().substring(6, 13);
      final FactoryTag tag = FactoryTag(
          tag: data,
          productCode: productCode,
          quantity: quantity,
          codeType: 'SCAN');
      repository.add(tag);
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Produto em Processo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await LaunchApp.openApp(
                androidPackageName: 'com.rscja.scanner',
              );
              // handle the press
            },
          ),
        ],
      ),
      body: StreamBuilder<List<FactoryTag?>>(
        stream: repository.streamTags,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final tags = snapshot.data!;
          return ListView.builder(
              itemCount: tags.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    color: Colors.grey,
                    child: ListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(tags[index]!.tag),
                      subtitle: Text(
                          'Produto: ${tags[index]!.productCode} Quant.:${tags[index]!.quantity}'),
                      trailing: const FaIcon(FontAwesomeIcons.fileSignature),
                      //trailing: const FaIcon(FontAwesomeIcons.barcode),
                      onLongPress: () {
                        repository.deleteTag(tags[index]!);
                      },
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* 
          addTag("026193  72,01");
          addTag("0261931172,01");
          addTag("026193   1,01");
          addTag("02619    1,x1");
          addTag("02619    1,xx");
          addTag("02619    1,1");
          addTag("02619    1,"); */
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
