import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meuestoque_protheus/core/error/failure.dart';

class EpcInventoryRepository {
  final baseUrl = dotenv.env['API'];

  Future<Either<Failure, dynamic>> postEpcInventory(String json) async {
    try {
      var response = await Dio().post('${baseUrl!}/inventario/', data: json);
      return Right(response.data);
    } catch (e) {
      return const Left(Failure("Server Error!"));
    }
  }
}
