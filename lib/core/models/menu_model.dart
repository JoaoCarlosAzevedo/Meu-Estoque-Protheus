import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class MenuItem {
  final String? title, totalStorage;
  final IconData? icon;
  final int? numOfFiles, percentage;
  final Color? color;
  final String route;

  MenuItem(
      {required this.icon,
      this.title,
      this.totalStorage,
      this.numOfFiles,
      this.percentage,
      this.color,
      required this.route});
}
