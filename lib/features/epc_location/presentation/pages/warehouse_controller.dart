import 'package:meuestoque_protheus/core/database/db.dart';
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';
import 'package:meuestoque_protheus/objectbox.g.dart';

class WarehousePageController {
  Box<EpcLocation> box = Db.store!.box<EpcLocation>();

  late Stream<EpcLocation?> stream;

  int id = -1;

  void addEpcLocation(EpcLocation epclocation) {
    box.put(epclocation);
  }

  void searchEpcLocation(String warehouse, String street, String shelf) {
    stream = box
        // The simplest possible query that just gets ALL the data out of the Box
        .query(EpcLocation_.armazem.equals(warehouse) &
            EpcLocation_.rua.equals(street) &
            EpcLocation_.coluna.equals(shelf))
        .watch(triggerImmediately: true)
        .map((query) {
      id = query.findFirst()!.id;
      print("o id: ${id.toString()}");

      return query.findFirst();
    });
  }
}
