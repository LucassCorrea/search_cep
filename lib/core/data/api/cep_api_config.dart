import 'package:flutter_dotenv/flutter_dotenv.dart';

class CEPApiConfig {
  static const String _urlApi = "https://parseapi.back4app.com/classes/CEP";

  static Map<String, String> headers = {
    "X-Parse-Application-Id": dotenv.env['APP_ID']!,
    "X-Parse-REST-API-Key": dotenv.env['RESTAPI_ID']!,
    "Content-Type": "application/json",
  };

  static String urlApi() => _urlApi;

  static String urlWithPrms(String cep) => "$_urlApi?where={\"cep\":\"$cep\"}";

  static String urlWithId(String id) => "$_urlApi/$id";
}
