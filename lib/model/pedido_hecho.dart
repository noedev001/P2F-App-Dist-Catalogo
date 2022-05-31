class PedidoHechoMet {
  String cantidadProductos;
  String precioTotal;
  String fecha;
  String estatus;

  PedidoHechoMet({
    required this.cantidadProductos,
    required this.precioTotal,
    required this.fecha,
    required this.estatus,
  });

  factory PedidoHechoMet.fromJson(Map<String, dynamic> json) => PedidoHechoMet(
        cantidadProductos: json["CantidadProductos"].toString(),
        precioTotal: json["PrecioTotal"].toString(),
        fecha: json["Fecha"].toString(),
        estatus: json["estatus"],
      );

  Map<String, dynamic> toJson() => {
        "CantidadProductos": cantidadProductos,
        "PrecioTotal": precioTotal,
        "Fecha": fecha,
        "estatus": estatus,
      };
}
