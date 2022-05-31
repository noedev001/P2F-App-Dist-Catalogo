class ProductCarrito {
  String id;
  String imagen;
  String nombre;
  String marca;
  String medida;
  String cantidadunidad;
  String cantidadcaja;
  String preciounidad;
  String cantidadunidadcaja;
  String preciototal;
  String fechapedido;
  String estatus;
  String nota;

  ProductCarrito(
      this.id,
      this.imagen,
      this.nombre,
      this.marca,
      this.medida,
      this.cantidadunidad,
      this.cantidadcaja,
      this.preciounidad,
      this.cantidadunidadcaja,
      this.preciototal,
      this.fechapedido,
      this.estatus,
      this.nota);

  ProductCarrito.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        imagen = json['avatarurl'],
        nombre = json['nombre'],
        marca = json['marca'],
        medida = json['medida'],
        cantidadunidad = json['cantidad_unidad'].toString(),
        cantidadcaja = json['cantidad_caja'].toString(),
        preciounidad = json['precio_unidad'].toString(),
        cantidadunidadcaja = json['cantidad_unidad_caja'].toString(),
        preciototal = json['precio_total'].toString(),
        fechapedido = json['fecha_pedido'].toString(),
        estatus = json['estatus'],
        nota = json['nota'];
}
