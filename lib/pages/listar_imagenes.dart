import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:animated_image_list/AnimatedImageList.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/image.dart';


//generate random name
String randomName() {
  var rng = new Random();
  var codeUnits = new List.generate(10, (index) {
    return rng.nextInt(26) + 65;
  });
  return new String.fromCharCodes(codeUnits);
}

Future<http.Response>postImageUrl(String username,String imageUrl){
  return http.post(Uri.parse('https://webmobilebackend.herokuapp.com/upload'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'username': username,
        'images': [imageUrl],
      }));
}





class ListaImagenes extends StatefulWidget {
  ListaImagenes({Key? key}) : super(key: key);



  @override
  State<ListaImagenes> createState() => _ListaImagenesState();
}

class _ListaImagenesState extends State<ListaImagenes> {
  File? image;

    final cloudinary = Cloudinary.full(
    apiKey: '279641576775559',
    apiSecret: 'j4kn_qNALQ2t3rkYZXG3Wj7WCyk',
    cloudName: 'dk0axnvfz',
    );
    Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      print('image: $image');
      if(image == null) return;

      final imageTemp = File(image.path);


      setState(() => this.image = imageTemp);

      final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: imageTemp.path,
        fileBytes: imageTemp.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: 'samples',
        fileName: randomName(),
        progressCallback: (count, total) {
          print(
            'Uploading image from file with progress: $count/$total');
;



          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                  content: Text('Imagen subida correctamente'),
                  action: SnackBarAction(label: 'Cerrar'  , onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }),
                        ), );


          }
          
          )
    );

  if(response.isSuccessful) {
    print('Get your image from with ${response.secureUrl}');  
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'email');

    //post image url

    postImageUrl( value!, response.secureUrl!).then((response) {
      print(response.body);
    }).catchError((error) {
      print(error);
    });

    print(value);
  }

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

  Imagen parseImagen(String responseBody){

    Imagen imagen = Imagen.fromJson(json.decode(responseBody));

    return imagen;

  }


  


  //fetch list of string
  Future<Imagen> fetchImages() async {
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'email');
  
   final response= await http.post(Uri.parse('https://webmobilebackend.herokuapp.com/getimages'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'username': value,
      }));

    return parseImagen(response.body);





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
    
      body:FutureBuilder(
        future: fetchImages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Imagen imagen = snapshot.data as Imagen;
            List<String> images = imagen.getImages();
            return AnimatedImageList(
              images: images,
              builder: (context,index,progress){
                return Positioned.directional(textDirection: TextDirection.ltr, child: 
                Opacity(
                  opacity: progress,
                  child: Image.network(images[index]),
                
                )
                
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
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
              onTap: (){
                //final storage = new FlutterSecureStorage();
                //String? value = await storage.read(key: 'email');
                //print(value);
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
