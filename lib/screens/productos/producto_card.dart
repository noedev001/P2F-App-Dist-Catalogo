import 'package:distribuidoraeye/model/productos.dart';
import 'package:distribuidoraeye/screens/productos/producto_detalle.dart';
import 'package:flutter/material.dart';

class ProductoCard extends StatefulWidget {
  final Product data;
  final String correo;
  ProductoCard(this.data, this.correo);

  @override
  _ProductoCardState createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductoDetalle(widget.correo, widget.data),
          ),
        );
      },
      child: Container(
        width: 250.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF616161),
                  blurRadius: 50.0,
                  spreadRadius: -40.0,
                  offset: Offset(10, 10))
            ],
            borderRadius: BorderRadius.circular(20.0)),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget.data.marca + "\n",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: widget.data.nombre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14.0))
                      ]),
                    ),
                  ),
                  Text(
                    "Bs" + widget.data.precio,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Positioned(
              top: 65.0,
              right: 25,
              child: Image.network(
                widget.data.imagen,
                height: 200,
                width: 220.0,
              ),
            ),
            Positioned(
                bottom: 25.0,
                left: 20.0,
                child: Text(
                  widget.data.modelo,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Positioned(
                bottom: 10.0,
                left: 20.0,
                child: Text(
                  widget.data.medida,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 40.0,
                width: 60.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
