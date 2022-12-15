import 'package:flutter/material.dart';

class MenuItemButtom {
  final String? title, totalStorage;
  final IconData? icon;
  final int? numOfFiles, percentage;
  final Color? color;
  final String route;

  MenuItemButtom(
      {required this.icon,
      this.title,
      this.totalStorage,
      this.numOfFiles,
      this.percentage,
      this.color,
      required this.route});
}
