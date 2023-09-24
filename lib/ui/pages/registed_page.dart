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
                      onTap: () {},
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
