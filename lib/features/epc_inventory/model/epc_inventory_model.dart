import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class EpcInventory {
  int id;
  String user;
  String obs;
  List<String> tags;
  EpcInventory({
    required this.id,
    required this.user,
    required this.obs,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'obs': obs,
      'tags': tags,
    };
  }

  factory EpcInventory.fromMap(Map<String, dynamic> map) {
    return EpcInventory(
      id: map['id']?.toInt() ?? 0,
      user: map['user'] ?? '',
      obs: map['obs'] ?? '',
      tags: List<String>.from(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EpcInventory.fromJson(String source) =>
      EpcInventory.fromMap(json.decode(source));
}
