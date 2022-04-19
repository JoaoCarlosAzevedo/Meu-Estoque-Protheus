import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:uhf_c72_plugin/tag_epc.dart';

class InventoryForm extends StatefulWidget {
  const InventoryForm({Key? key, required this.tags}) : super(key: key);
  final List<TagEpc> tags;

  @override
  State<InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<InventoryForm> {
  //final TextEditingController _userController = TextEditingController(text: '');
  //final TextEditingController _obsController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário de Etiquetas"),
        backgroundColor: secondaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text("Usuario"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              onSubmitted: (e) {},
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              decoration: const InputDecoration(
                label: Text("Observação"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              onSubmitted: (e) {},
            ),
          ],
        ),
      ),
    );
  }
}
