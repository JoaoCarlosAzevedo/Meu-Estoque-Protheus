import 'package:flutter/material.dart';
import 'package:meuestoque_protheus/features/epc_inventory/presentation/pages/inventory_coletor/inventory_coletor_page.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse/warehouse_page.dart';
import 'package:meuestoque_protheus/features/epc_location/presentation/pages/warehouse_sync/warehouse_sync_page.dart';
import 'package:meuestoque_protheus/pages/home/home_page.dart';

class AppRouter {
  /*
  late MachinesRepository machinesRepository;
  late MachinesCubit machinesCubit;
 */
  AppRouter() {
/*     machinesRepository =
        MachinesRepository(repository: MachinesNetworkService());
    machinesCubit = MachinesCubit(repository: machinesRepository); */
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());
      /* MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: machinesCubit,
            child: MachinesPage(),
          ),
        ); */
      case "/epclocation":
        return MaterialPageRoute(builder: (context) => const WarehousePage());

      case "/epclocationsync":
        return MaterialPageRoute(
            builder: (context) => const WarehoueSyncPage());

      case "/epcinventory":
        return MaterialPageRoute(
            builder: (context) => const InventoryColetorPage());

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
