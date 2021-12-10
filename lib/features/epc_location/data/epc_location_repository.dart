import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meuestoque_protheus/core/error/failure.dart';
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';

class EpcLocationRepository {
  final baseUrl = dotenv.env['API'];

  Future<Either<Failure, EpcLocation>> postEpcLocations(
      EpcLocation epcs) async {
    try {
      var response =
          await Dio().post('${baseUrl!}/v2enderecamento/', data: epcs.toJson());
      final epcResponse = EpcLocation.fromMap(response.data);
      return Right(epcResponse);
    } catch (e) {
      return const Left(Failure("Server Error!"));
    }
  }
}
 