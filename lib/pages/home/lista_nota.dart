import 'package:flutter/material.dart';
import 'package:notesapp/pages/constant/rutas.dart';
import 'package:notesapp/sqlite/model/nota.dart';
import 'package:notesapp/sqlite/sqlite_delete.dart';
import 'package:notesapp/sqlite/sqlite_helper.dart';
import 'package:notesapp/sqlite/sqlite_query.dart';
import 'package:provider/provider.dart';

class ListaNota extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaNotaState();
}








class _ListaNotaState extends State<ListaNota> {
  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  Future<void> _loadProviderData() async {
    final SQliteQuery sqliteQuery =
        Provider.of<SQliteQuery>(context, listen: false);
    await _delayed(true, Duration(milliseconds: 500));
    sqliteQuery.updateNotas();
  }

  Future<dynamic> _delayed(dynamic returVal, Duration duration) {
    return Future.delayed(duration, () => returVal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Lista de notas'),
        ),
      ),
      body: FutureBuilder(
        future: SQLiteHelper.getDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _mostrarLista(context);
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirAnadirNota(context),
        // ignore: prefer_const_constructors
        child: Icon(Icons.add),
      ),
    );
  }

  _mostrarLista(BuildContext context) {
    final SQliteQuery sqLiteQuery = Provider.of<SQliteQuery>(context);

    return ListView.builder(
      itemCount: sqLiteQuery.nota.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.delete),
              )),
          confirmDismiss: (direction) async {
            final bool result = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Estás seguro?'),
                content: const Text('¿Deseas eliminar esta nota?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.of(context).pop(true),
                      SQLiteDelete().nota(sqLiteQuery.nota[index]),
                      sqLiteQuery.updateNotas(),
                    },
                    child: const Text('Sí'),
                  ),
                ],
              ),
            );
          },
          key: Key(sqLiteQuery.nota[index].id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            SQLiteDelete().nota(sqLiteQuery.nota[index]);
            sqLiteQuery.updateNotas();
          },
          child: ListTile(
            title: Text(sqLiteQuery.nota[index].titulo),
            subtitle: Text(sqLiteQuery.nota[index].descripcion),
            trailing: ElevatedButton.icon(
                onPressed: () {
                  _abrirEditarNota(context, sqLiteQuery.nota[index]);
                },
                icon: Icon(Icons.edit),
                label: Text('Editar')),
          ),
        );
      },
    );
  }

  void _abrirAnadirNota(BuildContext context) {
    Navigator.pushNamed(context, Rutas.anadirNota).then((value) {
      Provider.of<SQliteQuery>(context, listen: false).updateNotas();
    });
  }

  void _abrirEditarNota(BuildContext context, Nota nota) {
    Navigator.pushNamed(context, Rutas.editarNota, arguments: nota)
        .then((value) {
      Provider.of<SQliteQuery>(context, listen: false).updateNotas();
    });
  }
}
