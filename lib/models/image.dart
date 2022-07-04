class Imagen {
  // ignore: non_constant_identifier_names, prefer_typing_uninitialized_variables
  late List<String> images;

  Imagen({required this.images});

  Imagen.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['images'] = images;
    return data;
  }

  

  //get list of images
  List<String> getImages() {
    return images;
  }
}