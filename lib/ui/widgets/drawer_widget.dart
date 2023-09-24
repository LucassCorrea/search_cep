import 'package:flutter/material.dart';
import 'package:search_cep/ui/pages/home_page.dart';
import 'package:search_cep/ui/pages/registed_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Map data = {
      0: {
        "title": "Consultar CEP",
        "icon": Icons.search_rounded,
        "color": Colors.black,
        "onPressed": const HomePage(),
      },
      1: {
        "title": "CEPs Cadastrados",
        "icon": Icons.list_alt_rounded,
        "color": Colors.black,
        "onPressed": const RegistedPage(),
      },
    };

    return SafeArea(
      child: Drawer(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: data.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                data[index]["title"],
              ),
              leading: Icon(
                data[index]["icon"],
              ),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => data[index]['onPressed'],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
