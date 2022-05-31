class FacturaList {
  FacturaList({
    required this.id,
    required this.factura,
    required this.fecha,
    required this.facturaurl,
  });

  String id;
  String factura;
  String fecha;
  String facturaurl;

  factory FacturaList.fromJson(Map<String, dynamic> json) => FacturaList(
        id: json["id"].toString(),
        factura: json["factura"].toString(),
        fecha: json["fecha"].toString(),
        facturaurl: json["facturaurl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "factura": factura.toString(),
        "fecha": fecha.toString(),
        "facturaurl": facturaurl.toString(),
      };
}
