import 'dart:convert';

import 'package:search_cep/core/data/api/viacep_api_config.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/service/cep_service.dart';
import 'package:http/http.dart' as http;
import 'package:search_cep/core/utils/exceptions/api_exception.dart';

class ViaCepRepository implements CEPService {
  @override
  Future<CEPModel?> get(String cep) async {
    try {
      var response = await http.get(
        Uri.parse(ViaCepApiConfig.urlApi(cep)),
      );

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (json['erro'] != true) {
          return CEPModel.fromJson(json);
        }
      } else {
        throw ApiException(
          "Erro ao realizar operação",
          "Por favor, tente novamente...",
        );
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
