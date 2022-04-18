import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/warehouses.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/warehouse_controller.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/widgets/shelf_radio.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/widgets/streetlist_dropdown.dart';

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
  final focusNode = InputWithKeyboardControlFocusNode();

  var myMenuItems = <String>[
    'Deletar Todos',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Deletar Todos':
        setState(() {
          widget.aEpcs.clear();
        });
        break;
    }
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
                              style: TextStyles.titleHome,
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
                      InputWithKeyboardControl(
                        focusNode: focusNode,
                        onSubmitted: (value) {
                          var aux = value.splitByLength(24, value);
                          setState(() {
                            for (var element in aux) {
                              if (!widget.aEpcs.contains(element)) {
                                widget.aEpcs.add(element);
                              }
                            }
                          });

                          /*  if (!widget.aEpcs.contains(value)) {
                            setState(() {
                              widget.aEpcs.add(value);
                            });
                          } */
                          focusNode.requestFocus();
                          textController.clear();
                        },
                        autofocus: true,
                        controller: textController,
                        width: double.infinity,
                        startShowKeyboard: false,
                        buttonColorEnabled: Colors.blue,
                        buttonColorDisabled: Colors.red,
                        underlineColor: Colors.white,
                        showUnderline: false,
                        showButton: false,
                        style: const TextStyle(color: Colors.white),
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

extension on String {
  List<String> splitByLength(int length, String string) {
    var nMax = 0;
    var char = "";
    List<String> data = [];

    for (int i = 0; i < string.length; i++) {
      char += string[i];
      nMax++;
      if (nMax == length) {
        data.add(char);
        char = "";
        nMax = 0;
      }
    }

    return data;
  }
}
