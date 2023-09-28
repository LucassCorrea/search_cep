import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/repository/cep_repository.dart';
import 'package:search_cep/core/utils/validators/validator.dart';

class InfoPage extends StatefulWidget {
  final CEPModel cepModel;

  const InfoPage({super.key, required this.cepModel});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _formKey = GlobalKey<FormState>();
  var isEditable = false;
  var repository = CEPRepository();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cepModel = widget.cepModel;

    Map data = {
      0: {
        "title": "CEP",
        "controller": TextEditingController(text: cepModel.cep),
      },
      1: {
        "title": "Logradouro",
        "controller": TextEditingController(text: cepModel.logradouro),
      },
      2: {
        "title": "Complemento",
        "controller": TextEditingController(text: cepModel.complemento),
      },
      3: {
        "title": "Bairro",
        "controller": TextEditingController(text: cepModel.bairro),
      },
      4: {
        "title": "Cidade",
        "controller": TextEditingController(text: cepModel.localidade),
      },
      5: {
        "title": "UF",
        "controller": TextEditingController(text: cepModel.uf),
      },
      6: {
        "title": "DDD",
        "controller": TextEditingController(text: cepModel.ddd),
      },
      7: {
        "title": "IGBE",
        "controller": TextEditingController(text: cepModel.ibge),
      },
      8: {
        "title": "GIA",
        "controller": TextEditingController(text: cepModel.gia),
      },
      9: {
        "title": "SIAFI",
        "controller": TextEditingController(text: cepModel.siafi),
      },
    };

    updateInfo() async {
      if (isEditable) {
        if (_formKey.currentState!.validate()) {
          cepModel.cep = data[0]['controller'].text;
          cepModel.logradouro = data[1]['controller'].text;
          cepModel.complemento = data[2]['controller'].text;
          cepModel.bairro = data[3]['controller'].text;
          cepModel.localidade = data[4]['controller'].text;
          cepModel.uf = data[5]['controller'].text;
          cepModel.ddd = data[6]['controller'].text;
          cepModel.ibge = data[7]['controller'].text;
          cepModel.gia = data[8]['controller'].text;
          cepModel.siafi = data[9]['controller'].text;

          await repository.put(cepModel);

          setState(() {
            isEditable = !isEditable;
          });
        }
      } else {
        setState(() {
          isEditable = !isEditable;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informações"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await updateInfo();
        },
        child: Icon(
          isEditable ? Icons.save_rounded : Icons.edit_rounded,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          itemCount: data.length,
          separatorBuilder: (context, index) => const Divider(
            color: Colors.transparent,
          ),
          itemBuilder: (context, index) {
            var title = data[index]['title'];
            var controller = data[index]['controller'];

            return ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: isEditable
                  ? TextFormField(
                      controller: controller,
                      validator: (value) => index == 0
                          ? Validator.inserirCEP(value)
                          : index == 4 || index == 5
                              ? Validator.inserirDados(value)
                              : index == 6
                                  ? Validator.inserirDDD(value)
                                  : null,
                      keyboardType: (index == 0 || index > 5)
                          ? TextInputType.number
                          : TextInputType.text,
                      maxLength: index == 0
                          ? 8
                          : index == 5
                              ? 2
                              : index == 6
                                  ? 2
                                  : null,
                      inputFormatters: [
                        if (index == 0 || index > 5)
                          FilteringTextInputFormatter.digitsOnly
                      ],
                    )
                  : Text(
                      controller.text,
                      style: const TextStyle(color: Colors.black54),
                    ),
            );
          },
        ),
      ),
    );
  }
}
