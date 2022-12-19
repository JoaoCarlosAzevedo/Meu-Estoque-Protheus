import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
// ignore: must_be_immutable
class FactoryTag extends Equatable {
  int id;
  final String tag;
  final String productCode;
  final String quantity;
  final String codeType;

  FactoryTag({
    this.id = 0,
    required this.tag,
    required this.productCode,
    required this.quantity,
    required this.codeType,
  });

  @override
  List<Object> get props => [
        id,
        tag,
        productCode,
        quantity,
        codeType,
      ];
}
