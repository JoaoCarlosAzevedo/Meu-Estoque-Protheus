import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models/menu_model.dart';
import 'models/warehouses.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

List menuItens = [
  MenuItemButtom(
    title: "Invetário RFID",
    numOfFiles: 1328,
    icon: FontAwesomeIcons.clipboardList,
    totalStorage: "1GB",
    color: const Color(0xFFA4CDFF),
    percentage: 10,
    route: 'epcinventory',
  ),
  MenuItemButtom(
    title: "Endereçar RFID",
    numOfFiles: 1328,
    icon: FontAwesomeIcons.warehouse,
    totalStorage: "1.9GB",
    color: primaryColor,
    percentage: 35,
    route: 'epclocation',
  ),
  MenuItemButtom(
      title: "Sincronizar RFID",
      numOfFiles: 1328,
      icon: FontAwesomeIcons.clipboardCheck,
      totalStorage: "2.9GB",
      color: const Color(0xFFFFA113),
      percentage: 35,
      route: 'epclocationsync'),
  MenuItemButtom(
      title: "Inventário Produto em Processo",
      numOfFiles: 1328,
      icon: FontAwesomeIcons.industry,
      totalStorage: "2.9GB",
      color: const Color(0xFFFFA113),
      percentage: 35,
      route: 'inventoryfactory'),
  MenuItemButtom(
      title: "Inventário Produto Acabado",
      numOfFiles: 1328,
      icon: FontAwesomeIcons.dollyFlatbed,
      totalStorage: "2.9GB",
      color: const Color(0xFFFFA113),
      percentage: 35,
      route: 'inventoryshipment'),
];

List warehouses = [
  Warehouse(
    warehouseName: "Armazem 1",
    streets: [for (var i = 1; i <= 18; i++) i.toString()],
    shelf: ['A', 'B'],
  ),
  Warehouse(
    warehouseName: "Armazem 2",
    streets: [for (var i = 1; i <= 15; i++) i.toString()],
    shelf: ['N'],
  ),
  Warehouse(
    warehouseName: "Armazem 3",
    streets: [for (var i = 1; i <= 11; i++) i.toString()],
    shelf: ['A', 'B'],
  ),
  Warehouse(
    warehouseName: "Armazem 4",
    streets: [for (var i = 1; i <= 11; i++) i.toString()],
    shelf: ['N'],
  ),
  Warehouse(
    warehouseName: "Tintas",
    streets: [for (var i = 1; i <= 1; i++) i.toString()],
    shelf: ['N'],
  ),
  Warehouse(
    warehouseName: "Sobras",
    streets: [for (var i = 1; i <= 14; i++) i.toString()],
    shelf: ['N'],
  ),
];
