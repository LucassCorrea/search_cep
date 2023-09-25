import 'package:flutter/material.dart';
import 'package:search_cep/core/data/model/cep_model.dart';
import 'package:search_cep/core/data/repository/cep_repository.dart';
import 'package:search_cep/ui/pages/add_page.dart';
import 'package:search_cep/ui/widgets/dialogs_widget.dart';
import 'package:search_cep/ui/widgets/drawer_widget.dart';

class RegistedPage extends StatefulWidget {
  const RegistedPage({super.key});

  @override
  State<RegistedPage> createState() => _RegistedPageState();
}

class _RegistedPageState extends State<RegistedPage> {
  var repository = CEPRepository();

  Future<List<CEPModel>> loadingData() async {
    return await repository.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CEPs Cadastrados")),
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddPage(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: loadingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Ocorreu um erro!"),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<CEPModel>? data = snapshot.data;

            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: data!.length,
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.transparent);
                },
                itemBuilder: (context, index) {
                  var cepModel = data[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await Dialogs.confirmDele(context);
                    },
                    onDismissed: (direction) async {
                      await repository.delete(cepModel.objectId!);
                      setState(() {});
                    },
                    child: ListTile(
                      tileColor: Colors.deepPurple.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        cepModel.cep!,
                      ),
                      onTap: () => showInfo(context, cepModel),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text("Sem dados cadastrados"));
          }
        },
      ),
    );
  }
}

showInfo(BuildContext context, CEPModel cepModel) {
  var data = {
    0: {"title": "CEP", "value": cepModel.cep},
    1: {"title": "Logradouro", "value": cepModel.logradouro},
    2: {"title": "Bairro", "value": cepModel.bairro},
    3: {"title": "Cidade", "value": cepModel.localidade},
    4: {"title": "Complemento", "value": cepModel.complemento},
    5: {"title": "UF", "value": cepModel.uf},
    6: {"title": "DDD", "value": cepModel.ddd},
    7: {"title": "IGBE", "value": cepModel.ibge},
    8: {"title": "GIA", "value": cepModel.gia},
    9: {"title": "SIAFI", "value": cepModel.siafi},
  };

  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Informações",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      var value = data[index]!['value'];
                      return ListTile(
                        title: Text(
                          data[index]!['title']!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          (value == null || value.isEmpty)
                              ? "Campo vázio"
                              : value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: (value == null || value.isEmpty)
                                ? Colors.grey.shade600
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
