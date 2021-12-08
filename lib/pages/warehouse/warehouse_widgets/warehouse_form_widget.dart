import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/warehouses.dart';
import 'package:meuestoque_protheus/features/stock_location/model/epc_locations_model.dart';
import 'package:meuestoque_protheus/objectbox.g.dart';
import 'package:meuestoque_protheus/pages/warehouse/warehouse_widgets/shelf_radio.dart';
import 'package:meuestoque_protheus/pages/warehouse/warehouse_widgets/streetlist_dropdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class WarehouseForm extends StatefulWidget {
  WarehouseForm({Key? key, required this.info}) : super(key: key);
  final Warehouse info;
  List<String> aEpcs = [];

  @override
  State<WarehouseForm> createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<WarehouseForm> {
  final TextEditingController _controller = TextEditingController();

  late Store _store;

  late Stream<EpcLocation?> _stream;

  int id = -1;

  bool hasBeenInitilized = false;

  final streetController = TextEditingController();

  final shelfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((dir) {
      _store =
          Store(getObjectBoxModel(), directory: join(dir.path, 'objectbox'));

      setState(() {
        hasBeenInitilized = true;

        streetController.text = widget.info.streets.first;
        shelfController.text = widget.info.shelf.first;

        _stream = _store
            .box<EpcLocation>()
            // The simplest possible query that just gets ALL the data out of the Box
            .query(EpcLocation_.armazem.equals(widget.info.warehouseName) &
                EpcLocation_.rua.equals(streetController.text) &
                EpcLocation_.coluna.equals(shelfController.text))
            .watch(triggerImmediately: true)
            // Watching the query produces a Stream<Query<ShopOrder>>
            // To get the actual data inside a List<ShopOrder>, we need to call find() on the query
            .map((query) {
          id = query.findFirst()!.id;

          print("o id: ${id.toString()}");

          return query.findFirst();
        });
      });
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  void handleSubmmit() {
    EpcLocation epcLocation = _store.box<EpcLocation>().get(id)!;

    epcLocation.epcs = widget.aEpcs;

    _store.box<EpcLocation>().put(epcLocation);

/*     EpcLocation location = EpcLocation(
        armazem: widget.info.warehouseName,
        coluna: shelfController.text,
        rua: streetController.text,
        epcs: widget.aEpcs);
    _store.box<EpcLocation>().put(location); */
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0.0,
      ),
      body: !hasBeenInitilized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 15.0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Código Lidos: ${widget.aEpcs.length}"),
                      TextButton(
                        onPressed: handleSubmmit,
                        child: const Text("Salvar"),
                      ),
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
                    child: StreamBuilder<EpcLocation?>(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          widget.aEpcs = snapshot.data!.epcs;

                          return ListView.builder(
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
                              });
                        }),
                  ),
                )
              ],
            ),
    );
  }
}
