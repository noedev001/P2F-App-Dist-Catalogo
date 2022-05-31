class Product {
  String id;
  String nombre;
  String marca;
  String medida;
  String modelo;
  String imagen;
  String precio;
  String descripcion;
  String categoria;
  String cantidadUnidad;
  String nota;
  String idproducto;

  Product(
      this.id,
      this.nombre,
      this.marca,
      this.medida,
      this.modelo,
      this.imagen,
      this.precio,
      this.descripcion,
      this.categoria,
      this.cantidadUnidad,
      this.nota,
      this.idproducto);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        nombre = json['nombre'].toString(),
        marca = json['marca'],
        medida = json['medida'].toString(),
        modelo = json['modelo'],
        imagen = json['avatarurl'].toString(),
        precio = json['precio_venta_unidad'].toString(),
        descripcion = json['descripcion'],
        categoria = json['nombrecategoria'],
        cantidadUnidad = json['cantidad_unidad_caja'].toString(),
        nota = json['nota'],
        idproducto = json['id_producto'].toString();
}
