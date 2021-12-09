import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meuestoque_protheus/features/epc_location/model/epc_locations_model.dart';

class LocationNetworkService {
  final baseUrl = dotenv.env['API'];

  Future<List<dynamic>> postEpcLocations(EpcLocation epcs) async {
    try {
      var url = Uri.parse('${baseUrl!}/epc/');
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: epcs.toJson());
      final responseConverted = const Utf8Decoder().convert(response.bodyBytes);
      return jsonDecode(responseConverted);
    } catch (e) {
      return [];
    }
  }
}
