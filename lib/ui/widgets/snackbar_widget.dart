import 'package:flutter/material.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/ui/pages/add_page.dart';

class SnackbarMessengerWidget {
  static validateCep(BuildContext context, CEPModel? cepModel) {
    if (cepModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("CEP não encontrado, deseja cadastrar?"),
          action: SnackBarAction(
            label: "Cadastrar",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPage(),
              ),
            ),
          ),
        ),
      );
    }
  }
}
