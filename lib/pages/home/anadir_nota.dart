import 'package:flutter/material.dart';
import 'package:notesapp/sqlite/model/nota.dart';
import 'package:notesapp/sqlite/sqlite_insert.dart';




class AnadirNota extends StatelessWidget {
  const AnadirNota({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Añadir nota'),
        ),
      ),
      body: _Formulario(),
    );
  }
}

class _Formulario extends StatelessWidget {
  final TextEditingController _controllerTitulo = TextEditingController();

  final TextEditingController _controllerDescripcion = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 25, left: 25, top: 25),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Por favor agrega un titulo';
                  }
                  return null;
                },
                controller: _controllerTitulo,
                decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Este campo no puede estar vacío';
                  }
                  return null;
                },
                maxLength: 400,
                maxLines: 8,
                controller: _controllerDescripcion,
                decoration: const InputDecoration(
                    labelText: 'Descripcion',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: () => _guardar(context),
                  icon: Icon(Icons.save),
                  label: Text('Guardar'))
            ],
          ),
        ),
      ),
    );
  }

  void _guardar(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      SQLiteInsert().nota(
        Nota(
          titulo: _controllerTitulo.text.trim(),
          descripcion: _controllerDescripcion.text.trim(),
        ),
      );
      Navigator.pop(context);
    }
  }
}
