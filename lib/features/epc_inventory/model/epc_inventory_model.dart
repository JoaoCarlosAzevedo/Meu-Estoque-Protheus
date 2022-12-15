import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class EpcInventory extends Equatable {
  int id;
  String user;
  String obs;
  String data;
  List<String> tags;

  EpcInventory({
    this.id = 0,
    required this.user,
    required this.obs,
    required this.data,
    required this.tags,
  });

  @override
  List<Object> get props => [user, obs, data, tags];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'obs': obs,
      'data': data,
      'tags': tags,
    };
  }

  factory EpcInventory.fromMap(Map<String, dynamic> map) {
    return EpcInventory(
      id: map['id']?.toInt() ?? 0,
      user: map['user'] ?? '',
      obs: map['obs'] ?? '',
      data: map['data'] ?? '',
      tags: List<String>.from(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EpcInventory.fromJson(String source) =>
      EpcInventory.fromMap(json.decode(source));
}
