import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/routes/routes.dart';
import 'features/stock_location/data/epc_location_repository.dart';
import 'features/stock_location/data/epc_location_service.dart';
import 'features/stock_location/model/epc_locations_model.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  var epcRepository = EpcLocationRepository(service: LocationNetworkService());
  var epcBody = EpcLocation(
      armazem: "armazem teste",
      rua: 1,
      coluna: "A",
      epcs: ["a", "b", "c", "d"]);

  epcRepository.postEpcLocation(epcBody);
/*   
  runApp(
    MeuEstoqueApp(
      router: AppRouter(),
    ),
  );
   */
}

class MeuEstoqueApp extends StatelessWidget {
  final AppRouter router;

  const MeuEstoqueApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: router.generateRoute,
    );
  }
}
