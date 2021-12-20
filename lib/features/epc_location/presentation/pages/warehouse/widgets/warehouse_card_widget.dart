import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meuestoque_protheus/core/constants.dart';
import 'package:meuestoque_protheus/core/models/warehouses.dart';

import 'warehouse_form_widget.dart';

class WareHouseCard extends StatelessWidget {
  const WareHouseCard({Key? key, required this.info}) : super(key: key);

  final Warehouse info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => WarehouseForm(info: info)));
      },
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  //padding: const EdgeInsets.all(defaultPadding * 0.75),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  //child: const Icon(Icons.access_alarm),
                  child: const Center(child: FaIcon(FontAwesomeIcons.boxes)),
                ),
                //const Icon(Icons.more_vert, color: Colors.white54)
              ],
            ),
            Text(
              info.warehouseName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.streets.length} Ruas",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white70),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
