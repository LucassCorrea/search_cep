import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_cep/core/data/api/cep_api_config.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/service/cep_service.dart';
import 'package:http/http.dart' as http;

class CEPRepository implements CEPService {
  @override
  Future<CEPModel?> get(String cep) async {
    try {
      var response = await http.get(
        Uri.parse(CEPApiConfig.urlWithPrms(cep)),
        headers: CEPApiConfig.headers,
      );

      if (response.statusCode == 200) {
        var results = <CEPModel>[];
        await jsonDecode(response.body)['results'].forEach((v) {
          results.add(CEPModel.fromJson(v));
        });

        if (results.isNotEmpty) {
          return results.first;
        }
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CEPModel>> getAll() async {
    try {
      var response = await http.get(
        Uri.parse(CEPApiConfig.urlApi()),
        headers: CEPApiConfig.headers,
      );

      if (response.statusCode == 200) {
        var results = <CEPModel>[];
        await jsonDecode(response.body)['results'].forEach((v) {
          results.add(CEPModel.fromJson(v));
        });

        if (results.isNotEmpty) {
          return results;
        }
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> post(CEPModel cepModel) async {
    try {
      var response = await http.post(
        Uri.parse(CEPApiConfig.urlApi()),
        headers: CEPApiConfig.headers,
        body: jsonEncode(cepModel.toJson()),
      );

      if (response.statusCode == 201) {
        debugPrint("Dados enviados com sucesso!");
      } else {
        debugPrint("Erro ao enviar dados!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> put(CEPModel cepModel) async {
    try {
      var response = await http.put(
        Uri.parse(CEPApiConfig.urlWithId(cepModel.objectId!)),
        headers: CEPApiConfig.headers,
        body: jsonEncode(cepModel.toJson()),
      );

      debugPrint(response.request.toString());
      debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint("Dados atualizados com sucesso!");
      } else {
        debugPrint("Erro ao atulizar dados!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      var response = await http.delete(
        Uri.parse(CEPApiConfig.urlWithId(id)),
        headers: CEPApiConfig.headers,
      );

      if (response.statusCode == 200) {
        debugPrint("Excluído com sucesso");
      } else {
        debugPrint("Erro ao deletar dados!");
      }
    } catch (e) {
      rethrow;
    }
  }
}
