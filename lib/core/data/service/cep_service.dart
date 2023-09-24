import 'package:search_cep/core/data/model/cep_model.dart';

abstract class CEPService {
  Future<CEPModel?> get(String cep);
}
