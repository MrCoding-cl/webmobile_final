import 'package:flutter/material.dart';
import 'package:notesapp/pages/home/editar_nota.dart';
import 'package:notesapp/pages/login/login_page.dart';
import 'package:notesapp/pages/register/register_page.dart';

import 'pages/constant/rutas.dart';
import 'pages/home/anadir_nota.dart';
import 'pages/home/lista_nota.dart';

import 'package:provider/provider.dart';

import 'sqlite/sqlite_query.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SQliteQuery>(
          create: (context) => SQliteQuery(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        // initialRoute: Rutas.home,
        initialRoute: Rutas.login,
        routes: {
          Rutas.home: (BuildContext context) => ListaNota(),
          Rutas.anadirNota: (BuildContext context) => const AnadirNota(),
          Rutas.editarNota: (BuildContext context) => const EditarNota(),
          Rutas.login: (BuildContext context) => LoginPage(),
          Rutas.register: (BuildContext context) => RegisterPage(),
        },
      ),
    );
  }
}
