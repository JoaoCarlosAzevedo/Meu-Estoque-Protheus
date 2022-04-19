import 'package:meuestoque_protheus/core/database/db.dart';
import 'package:meuestoque_protheus/features/epc_location/data/epc_location_repository.dart';
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';
import 'package:meuestoque_protheus/objectbox.g.dart';

class WarehouseSyncController {
  Box<EpcLocation> box = Db.store!.box<EpcLocation>();
  final remoteRepository = EpcLocationRepository();

  late Stream<List<EpcLocation?>> stream;

  void getAllWarerehouse() {
    stream = box
        .query()
        //.order(EpcLocation_.armazem, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) {
      return query.find().where((element) => element.epcs.isNotEmpty).toList();
    });
  }

  void post(EpcLocation epcs) async {
    var ret = await remoteRepository.postEpcLocations(epcs);
    if (ret.isRight()) {
      ret.fold((l) => null, (r) => updateEpcLocationDB(r.id, r.epcs));
    } else {
      ret.fold((l) => print(l.error), (r) => null);
    }
  }

  void updateEpcLocationDB(int id, List<String> epcs) {
    EpcLocation epcLocation = box.get(id)!;
    epcLocation.epcs = epcs;
    box.put(epcLocation);
  }
}
