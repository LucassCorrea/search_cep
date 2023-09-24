import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/repository/cep_repository.dart';
import 'package:search_cep/core/data/repository/viacep_repository.dart';
import 'package:search_cep/core/utils/validators/validator.dart';
import 'package:search_cep/ui/pages/add_page.dart';
import 'package:search_cep/ui/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  var controller = TextEditingController();
  var repositoryViaCep = ViaCepRepository();
  var resposityCEP = CEPRepository();
  CEPModel? cepModel;
  var loading = false;
  Map data = {};

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void searchCEP(String cep) async {
    List<CEPModel?> results = await Future.wait([
      repositoryViaCep.get(cep),
      resposityCEP.get(cep),
    ]);

    CEPModel? result1 = results[0];
    CEPModel? result2 = results[1];

    if (result1 != null) {
      cepModel = result1;
    } else if (result2 != null) {
      cepModel = result2;
    } else {
      cepModel = null;
    }

    if (cepModel != null) {
      data = {
        0: {
          "titulo": "Localidade",
          "valor": cepModel!.localidade,
        },
        1: {
          "titulo": "Logradouro",
          "valor": cepModel!.logradouro,
        },
        2: {
          "titulo": "Estado",
          "valor": cepModel!.uf,
        },
        3: {
          "titulo": "Bairro",
          "valor": cepModel!.bairro,
        },
        4: {
          "titulo": "Complemento",
          "valor": cepModel!.complemento,
        },
        5: {
          "titulo": "DDD",
          "valor": cepModel!.ddd,
        },
        6: {
          "titulo": "IBGE",
          "valor": cepModel!.ibge,
        },
        7: {
          "titulo": "DDD",
          "valor": cepModel!.siafi,
        },
      };
    }

    if (context.mounted) {
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Consultar CEP"),
          ),
          drawer: const DrawerWidget(),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                autofocus: true,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  if (_formKey.currentState!.validate()) {
                    searchCEP(value);
                  }
                },
                validator: (value) => Validator.inserirCEP(value),
                decoration: const InputDecoration(
                  hintText: "CEP",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
              if (cepModel != null)
                Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index]['titulo'],
                            ),
                            const SizedBox(height: 0),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                enabled: data[index]['valor'] != "",
                                hintText: data[index]['valor'] == ""
                                    ? "Vázio"
                                    : data[index]["valor"],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
