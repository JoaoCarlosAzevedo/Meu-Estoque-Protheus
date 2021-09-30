import 'dart:convert';

class EpcLocation {
  String armazem;
  int rua;
  String coluna;
  List<String> epcs;

  EpcLocation(
      {required this.armazem,
      required this.rua,
      required this.coluna,
      required this.epcs});

  Map<String, dynamic> toMap() {
    return {
      'armazem': armazem,
      'rua': rua,
      'coluna': coluna,
      'epcs': epcs,
    };
  }

  factory EpcLocation.fromMap(Map<String, dynamic> map) {
    return EpcLocation(
      armazem: map['armazem'],
      rua: map['rua'],
      coluna: map['coluna'],
      epcs: List<String>.from(map['epcs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EpcLocation.fromJson(String source) =>
      EpcLocation.fromMap(json.decode(source));
}
