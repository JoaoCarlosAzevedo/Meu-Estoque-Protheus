/* import 'package:meuestoque_protheus/core/database/db.dart';
import 'package:meuestoque_protheus/features/epc_inventory/data/epc_inventory_repository.dart';
import 'package:meuestoque_protheus/features/epc_inventory/model/epc_inventory_model.dart';
import 'package:objectbox/objectbox.dart';

class InventoryColetorController {
  Box<EpcInventory> box = Db.store!.box<EpcInventory>();
  late Stream<List<EpcInventory?>> stream;
  final remoteRepository = EpcInventoryRepository();

  void addEpc(EpcInventory epc) {
    box.put(epc);
  }

  void removeEpc(int id) {
    box.remove(id);
  }

  void removeAll() {
    box.removeAll();
  }

  void searchEcps() {
    stream = box.query().watch(triggerImmediately: true).map((query) {
      return query.find();
    });
  }

  void post(String json) async {
    var ret = await remoteRepository.postEpcInventory(json);
    if (ret.isRight()) {
      ret.fold((l) => null, (r) => clearEpcs(r));
    } else {
      ret.fold((l) => print(l.error), (r) => null);
    }
  }

  void clearEpcs(data) {
    final List<String> epcError = data['erros'].cast<String>();
    box.removeAll();
    for (var element in epcError) {
      addEpc(EpcInventory(epc: element));
    }
  }
}
 */