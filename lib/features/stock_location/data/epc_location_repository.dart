import 'package:meuestoque_protheus/features/stock_location/data/epc_location_service.dart';
import 'package:meuestoque_protheus/features/stock_location/model/epc_locations_model.dart';

class EpcLocationRepository {
  final LocationNetworkService service;

  EpcLocationRepository({required this.service});

  Future<List<EpcLocation>> postEpcLocation(EpcLocation epcsLocation) async {
    final epcs = await service.postEpcLocations(epcsLocation);
    return epcs.map((e) => EpcLocation.fromJson(e)).toList();
  }
}
