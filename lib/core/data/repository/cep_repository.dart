import 'dart:convert';
import 'dart:io';

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
        jsonDecode(response.body)['results'].forEach((v) {
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
        jsonDecode(response.body)['results'].forEach((v) {
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
        debugPrint("Deu certo!");
      } else {
        debugPrint("Deu erro!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> put(CEPModel cepModel) {
    throw UnimplementedError();
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
        debugPrint("Erro");
      }
    } catch (e) {
      if (e is SocketException) {}
      rethrow;
    }
  }
}
