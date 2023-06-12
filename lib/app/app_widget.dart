import 'package:economizze/app/modules/home/list/list_bindings.dart';
import 'package:economizze/app/modules/home/list/list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: ListBinding(),
        themeMode: ThemeMode.light,
        home: const ListPage(),
        title: 'Lista de Compras',
        getPages: [
          GetPage(
            name: '/list',
            page: () => const ListPage(),
            binding: ListBinding(),
          ),
        ],
      ),
    );
  }
}
