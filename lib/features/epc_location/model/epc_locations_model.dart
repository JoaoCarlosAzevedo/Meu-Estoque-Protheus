import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../core/widgets/tag_reader/model/tags_model.dart';

@Entity()
class EpcLocation extends Equatable {
  int id;
  String armazem;
  String rua;
  String coluna;
  List<String> epcs;

  EpcLocation({
    this.id = 0,
    required this.armazem,
    required this.rua,
    required this.coluna,
    required this.epcs,
  });

  @override
  List<Object> get props => [
        armazem,
        rua,
        coluna,
        epcs,
      ];

  Map<String, dynamic> toMap() {
    return {
      'armazem': armazem,
      'rua': rua,
      'coluna': coluna,
      'epcs': epcs,
      'id': id
    };
  }

  factory EpcLocation.fromMap(Map<String, dynamic> map) {
    return EpcLocation(
      armazem: map['armazem'],
      rua: map['rua'],
      coluna: map['coluna'],
      id: map['id'],
      epcs: List<String>.from(map['epcs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EpcLocation.fromJson(String source) =>
      EpcLocation.fromMap(json.decode(source));
}
