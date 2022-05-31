class ProductosFactura {
  ProductosFactura({
    required this.nombre,
    required this.marca,
    required this.cantidadUnidadCaja,
    required this.cantidadUnidad,
    required this.cantidadCaja,
    required this.precioUnidad,
    required this.precioTotal,
  });

  String nombre;
  String marca;
  String cantidadUnidadCaja;
  String cantidadUnidad;
  String cantidadCaja;
  String precioUnidad;
  String precioTotal;

  factory ProductosFactura.fromJson(Map<String, dynamic> json) =>
      ProductosFactura(
        nombre: json["nombre"],
        marca: json["marca"],
        cantidadUnidadCaja: json["cantidad_unidad_caja"].toString(),
        cantidadUnidad: json["cantidad_unidad"].toString(),
        cantidadCaja: json["cantidad_caja"].toString(),
        precioUnidad: json["precio_unidad"].toString(),
        precioTotal: json["precio_total"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "marca": marca,
        "cantidad_unidad_caja": cantidadUnidadCaja.toString(),
        "cantidad_unidad": cantidadUnidad.toString(),
        "cantidad_caja": cantidadCaja.toString(),
        "precio_unidad": precioUnidad.toString(),
        "precio_total": precioTotal.toString(),
      };
}
