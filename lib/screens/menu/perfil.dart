import 'package:distribuidoraeye/api/api_cargar_perfil.dart';
import 'package:distribuidoraeye/api/api_editar_usuario.dart';
import 'package:flutter/material.dart';

class PerfilCliente extends StatefulWidget {
  final String email;
  PerfilCliente({required this.email});
  @override
  _PerfilClienteState createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  late String numero;
  late String nombre, apellido;
  late String telelfono, direccion;
  late String foto = 'Ninguno', ci;

  final _formKey = GlobalKey<FormState>();

  final nombresController = TextEditingController();
  final apellidosController = TextEditingController();
  final ciController = TextEditingController();
  final numeroController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  String message = '';

  @override
  void initState() {
    numero = '0';
    nombre = '';
    apellido = '';
    telelfono = '';
    direccion = '';
    ci = '';
    _cargarPerfil(widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil Usuario"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200.0,
            padding: EdgeInsets.only(bottom: 15.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: foto != 'Ninguno'
                        ? ClipOval(
                            child: FadeInImage.assetNetwork(
                              height: double.infinity,
                              width: double.infinity,
                              fadeInCurve: Curves.bounceInOut,
                              fadeOutDuration: Duration(milliseconds: 800),
                              placeholder: 'assets/loading.gif',
                              image: foto,
                            ),
                          )
                        : ClipOval(
                            child: Image.asset(
                              'assets/lauch.png',
                            ),
                          ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 5.0),
                ),
                Text(widget.email),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Center(
              // ignore: deprecated_member_use
              child: FlatButton(
                splashColor: Colors.grey[600],
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  showDialogEditarDatos(context, nombre, apellido, ci, numero,
                      telelfono, direccion);
                },
                child: Container(
                  child: Column(
                    children: [Icon(Icons.edit), Text("Editar Datos")],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blueGrey[800],
            height: 180.0,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Cuenta",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 19.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "$nombre  $apellido",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0),
                ),
                Divider(
                  color: Colors.blueGrey[500],
                ),
                Text(
                  ci != 'Ninguno' ? "Ci: $ci " : "Ci",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0),
                ),
                Divider(
                  color: Colors.blueGrey[500],
                ),
                Text(
                  numero != '0' ? "$numero" : "Numero De Celular",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0),
                ),
                Divider(
                  color: Colors.blueGrey[500],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.blueGrey[800],
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(top: 20.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  telelfono != "Ninguno" ? "$telelfono" : "Telefono",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0),
                ),
                Divider(
                  color: Colors.blueGrey[500],
                ),
                Text(
                  direccion != "Ninguno" ? "$direccion" : "Dirección",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0),
                ),
                Divider(
                  color: Colors.blueGrey[500],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showDialogEditarDatos(BuildContext context, String nombre, String apellido,
      String ci, String numero, String telefono, String direccion) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[900],
              ),
              padding: EdgeInsets.all(5),
              height: 550,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Stack(
                //crossAxisAlignment: CrossAxisAlignment.center,
                clipBehavior: Clip.none,
                children: <Widget>[
                  ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Nombre',
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: nombresController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'El nombre no puede estar vacío';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Apellidos',
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: apellidosController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Los apellidos no puede estar vacío';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Ci',
                                    labelStyle: TextStyle(fontSize: 14)),
                                controller: ciController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'El ci no puede estar vacío';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Numero de Celular',
                                  labelStyle: TextStyle(fontSize: 14),
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
                                height: 2,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Telefono',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                keyboardType: TextInputType.phone,
                                controller: telefonoController,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Direccion',
                                  labelStyle: TextStyle(fontSize: 14),
                                ),
                                //keyboardType: TextInputType.phone,
                                controller: direccionController,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(message),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      bottom: 40.0,
                      left: 40,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          //_eliminarArticuloCarrito(id.toString(), user);
                          if (_formKey.currentState!.validate()) {
                            var nom = nombresController.text;
                            var ap = apellidosController.text;
                            var c = ciController.text;
                            var nu = numeroController.text;
                            var te = telefonoController.text;
                            var d = direccionController.text;

                            editarUser(nom, ap, c, nu, te, d, widget.email);

                            Navigator.of(context).pop(true);
                          }
                        },
                        splashColor: Colors.blueGrey[900],
                        child: Container(
                          child: Row(
                            children: [Icon(Icons.done), Text(" Si!!")],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 40.0,
                      right: 40,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        color: Colors.red,
                        splashColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Text(" No "),
                              Icon(Icons.cancel_outlined),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _cargarPerfil(String user) async {
    final perfil = new Perfil();

    var listVar = await perfil.datosPerdil(user);

    setState(() {
      this.nombre = listVar[0]['cli_nombres'].toString();
      this.apellido = listVar[0]['cli_apellidos'].toString();
      this.numero = listVar[0]['cli_celular'].toString();
      this.telelfono = listVar[0]['telefono'].toString();
      this.direccion = listVar[0]['direccion'].toString();
      this.foto = listVar[0]['foto'].toString();
      this.ci = listVar[0]['ci'].toString();

      nombresController.text = listVar[0]['cli_nombres'].toString();
      apellidosController.text = listVar[0]['cli_apellidos'].toString();
      ciController.text = listVar[0]['ci'].toString();
      numeroController.text = listVar[0]['cli_celular'].toString();
      telefonoController.text = listVar[0]['telefono'].toString();
      direccionController.text = listVar[0]['direccion'].toString();
    });
  }

  editarUser(String nombre, String apellido, String ci, String numero,
      String telefono, String direccion, String email) async {
    var rp = await cargarDatosUser(
        nombre, apellido, ci, numero, telefono, direccion, email);

    //print(rp);
    setState(() {
      this.nombre = rp[0]['cli_nombres'].toString();
      this.apellido = rp[0]['cli_apellidos'].toString();
      this.numero = rp[0]['cli_celular'].toString();
      this.telelfono = rp[0]['telefono'].toString();
      this.direccion = rp[0]['direccion'].toString();
      this.foto = rp[0]['foto'].toString();
      this.ci = rp[0]['ci'].toString();
      nombresController.text = rp[0]['cli_nombres'].toString();
      apellidosController.text = rp[0]['cli_apellidos'].toString();
      ciController.text = rp[0]['ci'].toString();
      numeroController.text = rp[0]['cli_celular'].toString();
      telefonoController.text = rp[0]['telefono'].toString();
      direccionController.text = rp[0]['direccion'].toString();
    });
  }
}
