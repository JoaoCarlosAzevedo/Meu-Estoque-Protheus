import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meuestoque_protheus/core/error/failure.dart';

class EpcInventoryRepository {
  //final baseUrl = dotenv.env['API'];
  final baseUrl = 'http://192.168.0.47:1880';

  Future<Either<Failure, dynamic>> postEpcInventory(String json) async {
    try {
      var response = await Dio().post('$baseUrl/inventario/', data: json);
      //var response = await Dio().post('${baseUrl!}/inventario/', data: json);
      if (response.statusCode == 201) {
        print("ok");
      }
      return Right(response.data);
    } catch (e) {
      return const Left(Failure("Server Error!"));
    }
  }
}
