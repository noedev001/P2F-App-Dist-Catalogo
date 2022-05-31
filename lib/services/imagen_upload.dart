import 'dart:io';
import 'package:distribuidoraeye/general/url.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  final String cliente;
  UploadImage(this.cliente);
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  late File _image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final asuntoController = TextEditingController();

  String cargarimagen = '0';

  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        cargarimagen = '1';
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    asuntoController.dispose();
    super.dispose();
  }

  Future uploadImage() async {
    var uri = Uri.parse(GloblaURL().urlGlobal() + "upload_imagen.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text.toString();
    request.fields['asunto'] = asuntoController.text.toString();
    request.fields['cliente'] = widget.cliente.toString();
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploded');
    } else {
      print('Image Not Uploded');
    }
    setState(() {
      //ProductosAdquiridos(widget.cliente).createState().vista(widget.cliente);
    });
  }

  bool si = true;
  List<dynamic> lis = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargar Imagen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.camera,
                size: 35.0,
              ),
              onPressed: () {
                choiceImage();
              },
            ),
            Container(
              // ignore: unnecessary_null_comparison
              //height: _image == null ? 20.0 : 400.0,
              //height: 400.0,
              height: cargarimagen == '0' ? 20.0 : 400.0,
              // ignore: unnecessary_null_comparison
              child: cargarimagen == '0'
                  ? Icon(
                      Icons.arrow_upward,
                      color: Theme.of(context).primaryColor,
                    )
                  : Image.file(_image),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // ignore: unnecessary_null_comparison
              child: cargarimagen == '0'
                  ? Text('Imagen no Seleccionada')
                  // ignore: deprecated_member_use
                  : RaisedButton(
                      child: Text('Enviar Imagen'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          //uploadImage();

                          /*Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return new ProductosAdquiridos(widget.cliente);
                          }));*/

                          lis = [
                            nameController.text.toString(),
                            asuntoController.text.toString(),
                            widget.cliente,
                            _image
                          ];

                          Navigator.pop(context, lis);
                        }
                      },
                    ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration:
                            InputDecoration(labelText: 'Monto a Enviar?'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Llene este campo";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: asuntoController,
                        decoration: InputDecoration(
                            labelText: 'Agregar Asunto',
                            hintText: "Ej: Primea Cuota..",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
