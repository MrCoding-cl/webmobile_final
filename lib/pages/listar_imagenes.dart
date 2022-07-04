import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ListaImagenes extends StatefulWidget {
  ListaImagenes({Key? key}) : super(key: key);

  @override
  State<ListaImagenes> createState() => _ListaImagenesState();
}

class _ListaImagenesState extends State<ListaImagenes> {
  File? image;
    Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de imagenes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          opciones(context);
        },
        child: const Icon(Icons.image),
      ),
    
      body: Center(
        child: Text('Lista de imagenes'),
      ),
    );
  }
  
  opciones(BuildContext context) {
    showDialog(context: context, builder:(BuildContext context){
      return AlertDialog(
        title: const Text('Opciones'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Tomar foto'),
              onTap: () {
                pickImageC();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar foto'),
              onTap: () {
                pickImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });

    } 
  }
