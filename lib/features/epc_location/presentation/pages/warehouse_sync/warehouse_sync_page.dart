import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/themes/app_text_styles.dart';
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse_sync/warehouse_sync_controller.dart';

class WarehoueSyncPage extends StatefulWidget {
  const WarehoueSyncPage({Key? key}) : super(key: key);

  @override
  State<WarehoueSyncPage> createState() => _WarehoueSyncPageState();
}

class _WarehoueSyncPageState extends State<WarehoueSyncPage> {
  final warehouseSyncController = WarehouseSyncController();

  @override
  void initState() {
    super.initState();
    setState(() {
      warehouseSyncController.getAllWarerehouse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(FontAwesomeIcons.dollyFlatbed),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(FontAwesomeIcons.sync),
            SizedBox(width: 20),
            Text("Sincronizar RFID"),
          ],
        ),
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: StreamBuilder<List<EpcLocation?>>(
            stream: warehouseSyncController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data![index]!.armazem,
                          style: TextStyles.titleListTile,
                        ),
                        Text(
                          "Rua: ${snapshot.data![index]!.rua} ${snapshot.data![index]!.coluna}",
                          style: TextStyles.trailingBold,
                        ),
                      ],
                    ),
                    //leading: const Icon(Icons.qr_code_2),
                    subtitle: Text(
                        "EPCs: " +
                            snapshot.data![index]!.epcs.length.toString(),
                        style: TextStyles.trailingRegular),
                    visualDensity: VisualDensity.compact,
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        warehouseSyncController.post(snapshot.data![index]!);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
