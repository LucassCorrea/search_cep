import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/repository/cep_repository.dart';
import 'package:search_cep/core/utils/validators/validator.dart';
import 'package:search_cep/ui/widgets/dialogs_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  Map data = {
    0: {"titulo": "CEP", "controller": TextEditingController()},
    1: {"titulo": "Logradouro", "controller": TextEditingController(text: "")},
    2: {"titulo": "Complemento", "controller": TextEditingController(text: "")},
    3: {"titulo": "Bairro", "controller": TextEditingController(text: "")},
    4: {"titulo": "Cidade", "controller": TextEditingController(text: "")},
    5: {"titulo": "UF", "controller": TextEditingController(text: "")},
    6: {"titulo": "IGBE", "controller": TextEditingController(text: "")},
    7: {"titulo": "GIA", "controller": TextEditingController(text: "")},
    8: {"titulo": "DDD", "controller": TextEditingController(text: "")},
    9: {"titulo": "SIAFI", "controller": TextEditingController(text: "")},
  };

  var repository = CEPRepository();
  final _formKey = GlobalKey<FormState>();

  Future<void> postCEP() async {
    var cep = data[0]['controller'].text;
    var cepModel = await repository.get(cep);

    if (cep != cepModel?.cep) {
      return await repository.post(CEPModel(
        cep: data[0]['controller'].text,
        logradouro: data[1]['controller'].text,
        complemento: data[2]['controller'].text,
        bairro: data[3]['controller'].text,
        localidade: data[4]['controller'].text,
        uf: data[5]['controller'].text,
        ibge: data[6]['controller'].text,
        gia: data[7]['controller'].text,
        ddd: data[8]['controller'].text,
        siafi: data[9]['controller'].text,
      ));
    } else {
      if (context.mounted) {
        await Dialogs.errorCEP(context, msg: "CEP já registrado");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar CEP")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Column(
              children: List.generate(
                data.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data[index]['titulo']),
                        const SizedBox(height: 5),
                        TextFormField(
                          validator: (value) => index == 0
                              ? Validator.inserirCEP(value)
                              : index == 4 || index == 5
                                  ? Validator.inserirDados(value)
                                  : index == 8
                                      ? Validator.inserirDDD(value)
                                      : null,
                          maxLength: index == 0
                              ? 8
                              : index == 5
                                  ? 2
                                  : index == 8
                                      ? 2
                                      : null,
                          controller: data[index]['controller'],
                          decoration: const InputDecoration(),
                          keyboardType: (index == 0 || index > 5)
                              ? TextInputType.number
                              : TextInputType.text,
                          inputFormatters: [
                            if (index == 0 || index > 5)
                              FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await postCEP();
                  }
                },
                child: const Text("Adicionar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
