import 'package:flutter/material.dart';
import 'package:notesapp/pages/home/anadir_nota.dart';
import 'package:notesapp/pages/home/lista_nota.dart';
import 'package:notesapp/pages/listar_imagenes.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Lista de notas'),
        ),
      ),
      body:Column(
        children: [
          //create button
          TextButton(onPressed: 
            () {
              Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          //builder: (context) => ListaNota(),
                          builder: (context) => ListaNota(),
                        ),
                      );
            }, child: const Text('IR a notas')),
                      TextButton(onPressed: 
            () {
              Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          //builder: (context) => ListaNota(),
                          builder: (context) => ListaImagenes(),
                        ),
                      );
            }, child: const Text('IR a lista imagenes')),

        ],
      )
  
    );

  }
}