import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/widgets/warehouse_grid_widget.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: const Icon(FontAwesomeIcons.dollyFlatbed),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(FontAwesomeIcons.warehouse),
            SizedBox(width: 20),
            Text("Endereçamento"),
          ],
        ),
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: SingleChildScrollView(child: WarehousesGrid()),
        ),
      ),
    );
  }
}
