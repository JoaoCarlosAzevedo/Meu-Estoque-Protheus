import '../../../../objectbox.g.dart';
import '../../../database/db.dart';
import '../model/tags_model.dart';

class LocalTagsRepository {
  Box<Tags> box = Db.store!.box<Tags>();

  Stream<List<Tags>>? get streamTags =>
      box.query().watch(triggerImmediately: true).map((event) => event.find());

  void deleteAll() {
    box.removeAll();
  }

  void deleteTag(Tags tag) {
    box.remove(tag.id);
  }

  bool add(Tags tag) {
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
    return data.map((e) => e.data.trim()).toList();
  }

  List<String> getAllTagsToJson() {
    final query = box.query().build();
    final data = query.find();
    return data.map((e) => e.toJson()).toList();
  }
}
