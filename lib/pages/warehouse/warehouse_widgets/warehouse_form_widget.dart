import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/warehouses.dart';
import 'package:meuestoque_protheus/pages/warehouse/warehouse_widgets/shelf_radio.dart';
import 'package:meuestoque_protheus/pages/warehouse/warehouse_widgets/streetlist_dropdown.dart';

class WarehouseForm extends StatefulWidget {
  WarehouseForm({Key? key, required this.info}) : super(key: key);
  final Warehouse info;
  List<String> aEpcs = ['123', '29812', 'legal', 'showw'];

  @override
  State<WarehouseForm> createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<WarehouseForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final streetController = TextEditingController();
    final shelfController = TextEditingController();

    Set<String> setEpcs = {};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Container(
            height: height / 6,
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
            padding: const EdgeInsets.only(left: 10.0, right: 15.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Código Lidos: ${widget.aEpcs.length}"),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.aEpcs.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          TextField(
            maxLength: 24,
            controller: _controller,
            onSubmitted: (value) {
              setState(() {
                widget.aEpcs.add(value);
                _controller.clear();
              });
            },
            onChanged: (value) => print(value),
            autofocus: true,
            showCursor: true,
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
                  }),
            ),
          )
        ],
      ),
    );
  }
}
