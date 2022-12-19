import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/inventory_coletor_page.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/warehouse_page.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse_sync/warehouse_sync_page.dart';
import 'package:meuestoque_protheus/pages/home/home_page.dart';

import '../../features/factory_inventory/presentation/pages/factory_inventory/factory_inventory_page.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());

      case "/epclocation":
        return MaterialPageRoute(builder: (context) => const WarehousePage());

      case "/epclocationsync":
        return MaterialPageRoute(
            builder: (context) => const WarehoueSyncPage());

      case "/epcinventory":
        return MaterialPageRoute(
            builder: (context) => const InventoryColetorPage());

      case "/inventoryfactory":
        return MaterialPageRoute(
            builder: (context) => const FactoryInventoryPage());

      case "/inventoryshipment":
        return MaterialPageRoute(
            builder: (context) => const DefaultErrorPage());

      default:
        return MaterialPageRoute(
            builder: (context) => const DefaultErrorPage());
    }
  }
}

class DefaultErrorPage extends StatelessWidget {
  const DefaultErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Error"),
      ),
    );
  }
}
