import 'package:flutter/material.dart';
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
