import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/features/epc_inventory/model/epc_inventory_model.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/inventory_coletor_controller.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/widgets/inventory_form.dart';

class InventoryColetorPage extends StatefulWidget {
  const InventoryColetorPage({Key? key}) : super(key: key);

  @override
  State<InventoryColetorPage> createState() => _InventoryColetorPageState();
}

class _InventoryColetorPageState extends State<InventoryColetorPage> {
  final InventoryColetorController controller = InventoryColetorController();

  @override
  void initState() {
    controller.searchEcps();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventário com RFID"),
        centerTitle: true,
        backgroundColor: secondaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamBuilder<List<EpcInventory?>>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  EpcInventory epcinventory = snapshot.data![index]!;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          epcinventory.user,
                          style: TextStyles.titleListTile,
                        ),
                        Text(
                          "Etiquetas: ${epcinventory.tags.length}",
                          style: TextStyles.trailingBold,
                        ),
                      ],
                    ),
                    //leading: const Icon(Icons.qr_code_2),
                    subtitle: Text(epcinventory.obs,
                        style: TextStyles.trailingRegular),
                    visualDensity: VisualDensity.compact,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryForm(
                                      controller: controller,
                                      epcInventory: epcinventory,
                                    )));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventoryForm(
                controller: controller,
              ),
            ),
          );
        },
        backgroundColor: secondaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
