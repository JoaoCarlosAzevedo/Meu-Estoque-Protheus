import 'package:audioplayers/audioplayers.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/warehouses.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/warehouse_controller.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/widgets/shelf_radio.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/widgets/streetlist_dropdown.dart';

// ignore: must_be_immutable
class WarehouseForm extends StatefulWidget {
  WarehouseForm({Key? key, required this.info}) : super(key: key);
  final Warehouse info;
  List<String> aEpcs = [];

  @override
  State<WarehouseForm> createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<WarehouseForm> {
  bool hasBeenInitilized = false;

  final streetController = TextEditingController();

  final shelfController = TextEditingController();

  final warehousePageController = WarehousePageController();

  final textController = TextEditingController();

  final player = AudioCache();

  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "data.rfid",
      "data.barcode",
    ],
  );

  var myMenuItems = <String>[
    'Deletar Todos',
    'Config. Coletor',
  ];

  void onSelect(item) async {
    switch (item) {
      case 'Deletar Todos':
        setState(() {
          widget.aEpcs.clear();
        });
        break;
      case 'Config. Coletor':
        await LaunchApp.openApp(
          androidPackageName: 'com.rscja.scanner',
          // openStore: false
        );
        break;
    }
  }

  @override
  void dispose() {
    receiver.stop();
    //streetController.dispose();
    //shelfController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      hasBeenInitilized = true;

      streetController.text = widget.info.streets.first;
      shelfController.text = widget.info.shelf.first;

      warehousePageController.searchEpcLocation(widget.info.warehouseName,
          streetController.text, shelfController.text);
    });

    receiver.start();
    receiver.messages.listen(onRead);

    streetController.addListener(_listener);
    shelfController.addListener(_listener);
  }

  void _listener() {
    setState(() {
      widget.aEpcs.clear();
      warehousePageController.searchEpcLocation(widget.info.warehouseName,
          streetController.text, shelfController.text);
    });
  }

  void handleSubmmit() {
    EpcLocation location = EpcLocation(
        armazem: widget.info.warehouseName,
        coluna: shelfController.text,
        rua: streetController.text,
        epcs: widget.aEpcs);

    warehousePageController.epcLocationSave(
        warehousePageController.id, location, widget.aEpcs);
  }

  void onRead(BroadcastMessage message) {
    if (message.data!["SCAN_STATE"] == "success") {
      if (message.name == "data.rfid") {
        addTag(message.data!["data"]);
      }
    }
  }

  void addTag(String tag) {
    setState(() {
      if (!widget.aEpcs.contains(tag)) {
        widget.aEpcs.add(tag);
        player.play('beep.mp3');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0.0,
          actions: [
            PopupMenuButton<String>(
                onSelected: onSelect,
                itemBuilder: (BuildContext context) {
                  return myMenuItems.map((String choice) {
                    return PopupMenuItem<String>(
                      child: Text(choice),
                      value: choice,
                    );
                  }).toList();
                })
          ],
        ),
        body: !hasBeenInitilized
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<EpcLocation?>(
                stream: warehousePageController.stream,
                builder: (context, snapshot) {
                  widget.aEpcs =
                      snapshot.hasData ? snapshot.data!.epcs : widget.aEpcs;
                  return Column(
                    children: [
                      Container(
                        height: height / 5,
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Armazém"),
                                Text(widget.info.warehouseName),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Rua"),
                                StreetList(
                                  streetOptions: widget.info.streets,
                                  controller: streetController,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Coluna"),
                                ShelfOptions(
                                  options: widget.info.shelf,
                                  controller: shelfController,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 15.0, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("Código Lidos: "),
                            Text(
                              widget.aEpcs.length.toString(),
                              style: TextStyles.titleHomev2,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.save,
                                color: Colors.green,
                              ),
                              iconSize: 35,
                              onPressed: handleSubmmit,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: ListView.builder(
                            itemCount: widget.aEpcs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(widget.aEpcs[index]),
                                //leading: const Icon(Icons.qr_code_2),
                                minVerticalPadding: 0,
                                visualDensity: VisualDensity.compact,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    setState(() {
                                      widget.aEpcs.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }));
  }
}
