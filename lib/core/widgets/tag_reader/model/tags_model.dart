import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: must_be_immutable
class Tags extends Equatable {
  int id;

  @Unique()
  final String epc;
  final String data;
  final String barcode;
  final String codeType;
  final String rssi;

  Tags({
    this.id = 0,
    required this.data,
    required this.epc,
    required this.barcode,
    required this.codeType,
    required this.rssi,
  });

  @override
  List<Object> get props => [data, epc, barcode, codeType, rssi];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'epc': epc,
      'data': data,
      'barcode': barcode,
      'codeType': codeType,
      'rssi': rssi,
    };
  }

  factory Tags.fromMap(Map<String, dynamic> map) {
    return Tags(
      id: map['id']?.toInt() ?? 0,
      epc: map['epc'] ?? '',
      data: map['data'] ?? '',
      barcode: map['barcode'] ?? '',
      codeType: map['codeType'] ?? '',
      rssi: map['rssi'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tags.fromJson(String source) => Tags.fromMap(json.decode(source));
}
