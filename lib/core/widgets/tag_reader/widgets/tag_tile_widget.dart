import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import '../model/tags_model.dart';

class TagListTile extends StatelessWidget {
  const TagListTile({Key? key, required this.tag, this.onLongPress})
      : super(key: key);
  final Tags tag;
  final void Function()? onLongPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: onLongPress,
        title: Text(tag.data),
        visualDensity: VisualDensity.compact,
        trailing: tagType(tag.codeType, tag.rssi),
        /*    subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(tag.codeType),
            Text(tag.rssi),
          ],
        ), */
      ),
    );
  }

  Widget tagType(String type, String rssi) {
    switch (type) {
      case 'RFID':
        final double rssiSignal = double.parse(rssi.replaceFirst(',', '.'));
        return _iconType(rssiScale(rssiSignal));
      case "QR_CODE":
        return const FaIcon(FontAwesomeIcons.qrcode); // do something
      default:
        return const FaIcon(FontAwesomeIcons.barcode);
    }
  }

  Widget _iconType(num rssi) {
    return SignalStrengthIndicator.sector(
      barCount: 4,
      value: rssi,
      levels: <num, Color>{
        0.25: Colors.red,
        0.50: Colors.orange,
        0.75: Colors.yellow,
        0.90: Colors.green,
      },
      size: 15,
    );
  }

  double rssiScale(double rssi) {
    if (rssi > -65.00) {
      return 0.91;
    }

    if (rssi <= -65.00 && rssi > -75.00) {
      return 0.76;
    }

    if (rssi <= -75.00 && rssi > -80.00) {
      return 0.51;
    }

    if (rssi <= -80.00) {
      return 0.26;
    }

    return 0.0;
  }
}
