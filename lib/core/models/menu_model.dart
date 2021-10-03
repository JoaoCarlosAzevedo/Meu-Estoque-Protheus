import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class MenuItem {
  final String? title, totalStorage;
  final IconData? icon;
  final int? numOfFiles, percentage;
  final Color? color;

  MenuItem({
    required this.icon,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List menuItens = [
  MenuItem(
    title: "Endereçar RFID",
    numOfFiles: 1328,
    icon: FontAwesomeIcons.warehouse,
    totalStorage: "1.9GB",
    color: primaryColor,
    percentage: 35,
  ),
  MenuItem(
    title: "Invetário RFID",
    numOfFiles: 1328,
    icon: FontAwesomeIcons.clipboardCheck,
    totalStorage: "2.9GB",
    color: const Color(0xFFFFA113),
    percentage: 35,
  ),
  MenuItem(
    title: "Saldos",
    numOfFiles: 1328,
    icon: FontAwesomeIcons.clipboardList,
    totalStorage: "1GB",
    color: const Color(0xFFA4CDFF),
    percentage: 10,
  ),
  MenuItem(
    title: "Consultar Endereços",
    numOfFiles: 5328,
    icon: FontAwesomeIcons.dolly,
    totalStorage: "7.3GB",
    color: const Color(0xFF007EE5),
    percentage: 78,
  ),
];
