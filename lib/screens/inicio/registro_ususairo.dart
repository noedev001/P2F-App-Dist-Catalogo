import 'package:distribuidoraeye/api/api_registro_usuario.dart';
import 'package:distribuidoraeye/screens/inicio/custom_widgeth.dart';
import 'package:distribuidoraeye/screens/principal/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NuevoUsuario extends StatefulWidget {
  final String token;
  const NuevoUsuario(this.token);

  @override
  _NuevoUsuarioState createState() => _NuevoUsuarioState();
}

class _NuevoUsuarioState extends State<NuevoUsuario> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final numeroController = TextEditingController();
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          HeroImage(
            imgHeight: MediaQuery.of(context).size.height * 0.10,
          ),
          Text(
            "Registro Usuario",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.right,
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(fontSize: 16)),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'El email no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 16)),
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'El password no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Nombres',
                            labelStyle: TextStyle(fontSize: 16)),
                        controller: nombresController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'El nombre no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Apellidos',
                            labelStyle: TextStyle(fontSize: 16)),
                        controller: apellidosController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Los apellidos no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Numero de Celular',
                          labelStyle: TextStyle(fontSize: 16),
                        ),
                        keyboardType: TextInputType.phone,
                        controller: numeroController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'El numero de celular no puede estar vacío';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        onBtnPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var email = emailController.text;
                            var password = passwordController.text;
                            var nombres = nombresController.text;
                            var apellidos = apellidosController.text;
                            var numero = numeroController.text;

                            setState(() {
                              message = 'Cargando....';
                            });
                            var rsp = await registroUser(email, password,
                                nombres, apellidos, numero, widget.token);
                            print(rsp);
                            if (rsp.containsKey('status')) {
                              setState(() {
                                message = rsp['status_text'];
                              });
                              if (rsp['status'] == 1) {
                                guardarDatos(rsp['email']);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomePage(username: rsp['email']);
                                }));
                              }
                            } else {
                              setState(() {
                                message = 'Error Al Crear Cuenta';
                              });
                            }
                          }
                        },
                        btnText: 'Registrarse',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(message),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Future<void> guardarDatos(email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }
}
