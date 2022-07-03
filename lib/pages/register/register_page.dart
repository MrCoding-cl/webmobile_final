// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notesapp/pages/home/lista_nota.dart';
import 'package:notesapp/pages/login/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _RegisterScreen(),
      ),
    );
  }
}

class _RegisterScreen extends StatefulWidget {
  _RegisterScreen({Key? key}) : super(key: key);

  @override
  State<_RegisterScreen> createState() => __RegisterScreenState();
}

class __RegisterScreenState extends State<_RegisterScreen> {
  final TextEditingController _controllerEmail = TextEditingController();

  final TextEditingController _controllerPassword = TextEditingController();

  final TextEditingController _controllerUsername = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: prefer_const_constructors
                Text(
                  'Register',
                  // ignore: prefer_const_constructors
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 20),
                Image(
                    image: NetworkImage(
                        'https://uft.cl/images/la_universidad/imagen-corporativa/Institucional/Logo_FINIS_institucional.png')),
                const SizedBox(height: 20),
                SizedBox(
                  height: 44,
                ),
                // ignore: prefer_const_constructors
                TextFormField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerUsername,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.verified_user),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: ElevatedButton(
                  child: Text('Registro'),
                  onPressed: () async {
                    final message = await _AuthService().register(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text,
                      username: _controllerUsername.text,
                    );
                    // final message = 'dfssdf';
                    if (message == 'true') {
                      // if (message!.contains('provider')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuario creado correctamente'),
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else if (message != "true") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Datos invalidos'),
                        ),
                      );
                    }
                  },
                )),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text('O'),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: ElevatedButton(
                  child: Text('Login'),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                )),
              ])),
    );
  }
}

class _AuthService {
  register(
      {required String email,
      required String username,
      required String password}) async {
    var response = await http.post(
        Uri(
          scheme: 'https',
          host: 'arcane-refuge-59957.herokuapp.com',
          path: '/api/auth/local/register',
        ),
        body: {
          "username": username,
          "email": email,
          "password": password,
          "confirmed": "true"
        });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['jwt'].isNotEmpty) {
        return "true";
      }
    } else {
      return 'NO';
    }
  }
}
