import 'package:distribuidoraeye/model/producto_oferta.dart';
import 'package:distribuidoraeye/screens/productos/producto_detalle_oferta.dart';
import 'package:flutter/material.dart';

class ProductoOfertaCard extends StatelessWidget {
  final ProductOferta data;
  final String email;
  ProductoOfertaCard(this.data, this.email);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductoDetalleOferta(email, data)));
      },
      child: Container(
        width: 240.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.only(top: 20),
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
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: data.marca + "\n",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: data.nombre + "\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14.0)),
                        TextSpan(
                            text: 'Fecha limite ' + data.fecha,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 10.0))
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: -5.0,
                right: 18.0,
                child: Text(
                  "Bs " + data.precioVentaNuevo,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Positioned(
              top: 65.0,
              right: 15,
              child: Image.network(
                data.avatarurl,
                height: 180,
                width: 200.0,
              ),
            ),
            Positioned(
                bottom: 25.0,
                left: 20.0,
                child: Text(
                  data.modelo,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Positioned(
                bottom: 10.0,
                left: 20.0,
                child: Text(
                  data.medida,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            Positioned(
                bottom: 60,
                right: 10,
                child: Text(
                  data.oferta,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            Positioned(
                bottom: 45,
                right: 10,
                child: Text(
                  "Antes Bs" + data.precioVentaUnidad,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.lineThrough,
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
            )
          ],
        ),
      ),
    );
  }
}
