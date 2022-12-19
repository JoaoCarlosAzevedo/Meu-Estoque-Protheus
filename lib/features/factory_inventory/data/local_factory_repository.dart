import '../../../core/database/db.dart';
import '../../../objectbox.g.dart';
import '../model/factory_tag_model.dart';

class LocalFactoryRepository {
  Box<FactoryTag> box = Db.store!.box<FactoryTag>();

  Stream<List<FactoryTag>>? get streamTags =>
      box.query().watch(triggerImmediately: true).map((event) => event.find());

  void deleteAll() {
    box.removeAll();
  }

  void deleteTag(FactoryTag tag) {
    box.remove(tag.id);
  }

  bool add(FactoryTag tag) {
    try {
      box.put(tag);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<String> getAllTagsToString() {
    final query = box.query().build();
    final data = query.find();
    return data.map((e) => e.tag.trim()).toList();
  }
}
