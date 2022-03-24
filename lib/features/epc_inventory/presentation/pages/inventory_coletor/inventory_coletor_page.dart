import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/features/epc_inventory/model/epc_inventory_model.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/inventory_coletor_controller.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/widgets/input_no_keyboard.dart';

class InventoryColetorPage extends StatefulWidget {
  const InventoryColetorPage({Key? key}) : super(key: key);

  @override
  State<InventoryColetorPage> createState() => _InventoryColetorPageState();
}

class _InventoryColetorPageState extends State<InventoryColetorPage> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  List<String> aEpcs = [];
  final tags = <String>{};
  String _selectedValue = "";
  final InventoryColetorController controller = InventoryColetorController();
  final textController = TextEditingController();
  final focusNode = InputWithKeyboardControlv2FocusNode();

  @override
  void initState() {
    _selectedValue = formatter.format(DateTime.now().toUtc());
    controller.searchEcps();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data da contagem"),
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_rounded),
            onPressed: () {
              /*              Map<String, dynamic> json = {
                'armazem': '',
                'data': _selectedValue,
                'epcs': aEpcs.map((e) => e!.epc).toList()
              };
              //print(jsonEncode(json));
              controller.post(jsonEncode(json)); */
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: height / 4,
            width: width,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //const Text("Escolha a data da contagem"),
                DatePicker(
                  DateTime.now().subtract(const Duration(days: 10)),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.green,
                  selectedTextColor: Colors.white,
                  locale: 'pt-BR',
                  height: 100,
                  daysCount: 20,
                  monthTextStyle: TextStyles.input,
                  dateTextStyle: TextStyles.trailingRegular,
                  dayTextStyle: TextStyles.input,
                  onDateChange: (date) {
                    // New date selected
                    setState(() {
                      _selectedValue = formatter.format(date.toUtc());
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Data Inventário"),
                    Text(
                      _selectedValue,
                      style: TextStyles.titleListTile,
                    ),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder<List<EpcInventory?>>(
              stream: controller.stream,
              builder: (context, snapshot) {
                //if (snapshot.hasData) {
                //  aEpcs = snapshot.data!;
                //} else {
                //  aEpcs = [];
                //}
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Código Lidos: "),
                          Text(
                            aEpcs.length.toString(),
                            style: TextStyles.titleHome,
                          ),
                        ],
                      ),
                      InputWithKeyboardControlv2(
                        focusNode: focusNode,
                        onSubmitted: (value) {
                          focusNode.requestFocus();
                        },
                        onChanged: (value) {
                          print(value);

                          var splited = value.split("eol");

                          textController.clear();

                          for (var element in splited) {
                            if (element.trim().isNotEmpty) {
                              tags.add(element.trim());
                              //    print(element.trim());
                            }
                          }
                          setState(() {
                            aEpcs = tags.toList();
                          });

                          focusNode.requestFocus();

                          /* 
                          var splited = textController.text.split("eol");
                          for (var element in splited) {
                            if (element.trim().isNotEmpty) {
                              tags.add(element.trim());
                            }
                          } */
                          //tags.add(value.trim());

                          /*           setState(() {
                            aEpcs = tags.toList();
                          });
 */
                          //textController.clear();
                          focusNode.requestFocus();
                        },
                        autofocus: true,
                        controller: textController,
                        width: double.infinity,
                        startShowKeyboard: false,
                        buttonColorEnabled: Colors.blue,
                        buttonColorDisabled: Colors.red,
                        underlineColor: Colors.white,
                        showUnderline: false,
                        showButton: true,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: aEpcs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(aEpcs[index]),
                                visualDensity: VisualDensity.compact,
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      tags.clear();
                                      aEpcs.clear();
                                    });
                                  },
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
