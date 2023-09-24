class Validator {
  static String? inserirCEP(String? value) {
    if (value != null) {
      if (value.isEmpty || value.length < 8) {
        return "Preencha o campo inteiro";
      }
    }
    return null;
  }

  static String? inserirDados(String? value) {
    if (value != null) {
      if (value.isEmpty || value.length < 2) {
        return "Campo obrigatório";
      }
    }
    return null;
  }

  static String? inserirDDD(String? value) {
    if (value != null) {
      if (value.isEmpty || value.length < 2) {
        return "Campo obrigatório";
      }
    }
    return null;
  }
}
