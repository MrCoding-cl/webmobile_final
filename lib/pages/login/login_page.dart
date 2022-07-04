// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:notesapp/pages/home.dart';
import 'package:notesapp/pages/home/lista_nota.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _LoginScreen(),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  _LoginScreen({Key? key}) : super(key: key);

  @override
  State<_LoginScreen> createState() => __LoginScreenState();
}

class __LoginScreenState extends State<_LoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();

  final TextEditingController _controllerPassword = TextEditingController();

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
                Text(
                  'Login',
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
                TextFormField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Por favor agrega una pass';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Por favor agrega una pass';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: ElevatedButton(
                  onPressed: () async {
                    final message = await AuthService().login(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text,
                    );
                    // final message = 'dfssdf';
                    if (message == 'true') {
                      // if (message!.contains('provider')) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          //builder: (context) => ListaNota(),
                          builder: (context) => HomePage(),
                        ),
                      );
                    } else if (message != "true") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuario no valido'),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
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
                  child: Text('Registro'),
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  // onPressed: _submitCommand,
                )),
              ])),
    );
  }
}

class AuthService {
  login({required String email, required String password}) async {
    var response = await http.post(
        Uri(
          scheme: 'https',
          host: 'arcane-refuge-59957.herokuapp.com',
          path: '/api/auth/local',
        ),
        body: {
          "identifier": email,
          "password": password,
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
