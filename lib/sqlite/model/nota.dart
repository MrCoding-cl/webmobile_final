class Nota {
  final int? id;

  final String titulo;

  final String descripcion;

  Nota({this.id, required this.titulo, required this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }
}
