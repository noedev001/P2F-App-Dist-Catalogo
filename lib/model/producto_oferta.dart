class ProductOferta {
  String id;
  String nombre;
  String marca;
  String medida;
  String modelo;
  String oferta;
  String avatarurl;
  String precioVentaNuevo;
  String precioVentaUnidad;
  String idInventario;
  String idProducto;
  String descripcion;
  String categoria;
  String nota;
  String cantidadUnidadxcaja;
  String fecha;

  ProductOferta({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.medida,
    required this.modelo,
    required this.oferta,
    required this.avatarurl,
    required this.precioVentaNuevo,
    required this.precioVentaUnidad,
    required this.idInventario,
    required this.idProducto,
    required this.descripcion,
    required this.categoria,
    required this.nota,
    required this.cantidadUnidadxcaja,
    required this.fecha,
  });

  factory ProductOferta.fromJson(Map<String, dynamic> json) => ProductOferta(
        id: json["id"].toString(),
        nombre: json["nombre"],
        marca: json["marca"],
        medida: json["medida"],
        modelo: json["modelo"],
        oferta: json["oferta"],
        avatarurl: json["avatarurl"],
        precioVentaNuevo: json["precio_venta_nuevo"].toString(),
        precioVentaUnidad: json["precio_venta_unidad"].toString(),
        idInventario: json["id_inventario"].toString(),
        idProducto: json["id_producto"].toString(),
        descripcion: json["descripcion"],
        categoria: json["categoria"],
        nota: json["nota"],
        cantidadUnidadxcaja: json["cantidad_unidadxcaja"].toString(),
        fecha: json["fecha"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "marca": marca,
        "medida": medida,
        "modelo": modelo,
        "oferta": oferta,
        "avatarurl": avatarurl,
        "precio_venta_nuevo": precioVentaNuevo,
        "precio_venta_unidad": precioVentaUnidad,
        "id_inventario": idInventario,
        "id_producto": idProducto,
        "descripcion": descripcion,
        "categoria": categoria,
        "nota": nota,
        "cantidad_unidadxcaja": cantidadUnidadxcaja,
        "fecha": fecha,
      };
}
