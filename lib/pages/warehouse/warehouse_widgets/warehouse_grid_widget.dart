import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/pages/warehouse/warehouse_widgets/warehouse_card_widget.dart';

class WarehousesGrid extends StatelessWidget {
  const WarehousesGrid({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: warehouses.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        //childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => WareHouseCard(info: warehouses[index]),
    );
  }
}
