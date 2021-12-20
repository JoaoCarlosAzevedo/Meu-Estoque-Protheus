import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class EpcInventory {
  int id;
  String epc;
  EpcInventory({
    this.id = 0,
    required this.epc,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'epc': epc,
    };
  }

  factory EpcInventory.fromMap(Map<String, dynamic> map) {
    return EpcInventory(
      id: map['id']?.toInt() ?? 0,
      epc: map['epc'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EpcInventory.fromJson(String source) =>
      EpcInventory.fromMap(json.decode(source));
}
