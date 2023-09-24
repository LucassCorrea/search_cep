class CEPApiConfig {
  static const String _urlApi = "https://parseapi.back4app.com/classes/CEP";

  static Map<String, String> headers = {
    "X-Parse-Application-Id": "NRpHAncgst4GGhsyKycjh9iy2ZtUTUmWFaL6xXW8",
    "X-Parse-REST-API-Key": "6h8AT2UrngJr3kBGpFiNBJEqm1FinHcvY4qXKuYe",
    "Content-Type": "application/json",
  };

  static String urlApi() => _urlApi;

  static String urlWithPrms(String cep) => "$_urlApi?where={\"cep\":\"$cep\"}";

  static String urlWithId(String id) => "$_urlApi/$id";
}
