import 'dart:convert';

import 'package:search_cep/core/data/api/viacep_api_config.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/service/cep_service.dart';
import 'package:http/http.dart' as http;

class ViaCepRepository implements CEPService {
  @override
  Future<CEPModel?> get(String cep) async {
    try {
      var response = await http.get(
        Uri.parse(ViaCepApiConfig.urlApi(cep)),
      );

      var json = await jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['erro'] != true) {
          return CEPModel.fromJson(json);
        }
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
