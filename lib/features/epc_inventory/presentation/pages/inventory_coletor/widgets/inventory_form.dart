import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/themes/app_colors.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/core/widgets/reader/tag_reader_widget.dart';
import 'package:meuestoque_protheus/features/epc_inventory/model/epc_inventory_model.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/inventory_coletor_controller.dart';
import 'package:meuestoque_protheus/core/widgets/reader/input_no_keyboard.dart';
import 'package:meuestoque_protheus/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class InventoryForm extends StatefulWidget {
  const InventoryForm({Key? key, required this.controller, this.epcInventory})
      : super(key: key);
  final InventoryColetorController controller;
  final EpcInventory? epcInventory;
  @override
  State<InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<InventoryForm> {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  List<String> aEpcs = [];
  final tags = <String>{};
  String _selectedValue = "";
  //final InventoryColetorController controller = InventoryColetorController();
  final userController = TextEditingController();
  final obsController = TextEditingController();
  final focusNode = InputWithKeyboardControlv2FocusNode();

  @override
  void initState() {
    if (widget.epcInventory != null) {
      _selectedValue = widget.epcInventory!.data;
      tags.addAll(widget.epcInventory!.tags);
      userController.text = widget.epcInventory!.user;
      obsController.text = widget.epcInventory!.obs;
    } else {
      _selectedValue = formatter.format(DateTime.now().toUtc());
    }

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
        title: const Text("Inventário com RFID"),
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0,
        actions: [
          PopupMenuButton(
            color: secondaryColor,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  enabled: widget.epcInventory == null ? false : true,
                  value: 'sync',
                  child: const Text('Enviar ao ERP'),
                ),
                PopupMenuItem(
                  enabled: widget.epcInventory == null ? false : true,
                  value: 'excluir',
                  child: const Text('Excluir'),
                ),
                const PopupMenuItem(
                  value: 'limpar',
                  child: Text('Limpar Leitura'),
                )
              ];
            },
            onSelected: (String value) async {
              if (value == 'excluir') {
                deleteInventory();
              }

              if (value == 'limpar') {
                setState(() {
                  tags.clear();
                });
              }

              if (value == 'sync') {
                String msg = await widget.controller.post(widget.epcInventory!);
                showMessage(msg);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: userController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  //hintText: 'Usuário',
                  label: Text('Usuário'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: obsController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.chat_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  label: Text('Observação'),
                ),
              ),
            ),
            const Text("Etiquetas Lidas"),
            Text(
              '${tags.toList().length}',
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.secondary),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(15)),
                      ),
                      onPressed: saveInventory,
                      child: const Text('Salvar'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: AppColors.secondary,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.center_focus_strong),
                        color: Colors.white,
                        onPressed: () {
                          getTags();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveInventory() {
    Box<EpcInventory> box = widget.controller.box;

    if (widget.epcInventory == null) {
      EpcInventory inventory = EpcInventory(
        data: _selectedValue,
        obs: obsController.text,
        user: userController.text,
        tags: tags.toList(),
      );
      box.put(inventory);
    } else {
      EpcInventory epcLocation = box.get(widget.epcInventory!.id)!;

      epcLocation.data = _selectedValue;
      epcLocation.obs = obsController.text;
      epcLocation.user = userController.text;
      epcLocation.tags = tags.toList();

      box.put(epcLocation);
    }

    Navigator.of(context).pop();
  }

  void deleteInventory() {
    Box<EpcInventory> box = widget.controller.box;
    box.remove(widget.epcInventory!.id);
    Navigator.of(context).pop();
  }

  void showMessage(String msg) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirmação!'),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void getTags() async {
    List<String>? aEpc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TagReader(),
      ),
    );

    aEpc ??= [];
    setState(() {
      tags.addAll(aEpc!.toSet());
    });
  }
}
