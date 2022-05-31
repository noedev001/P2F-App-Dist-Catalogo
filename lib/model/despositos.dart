class Deposito {
  int id;
  String asunto;
  String monto;
  String foto;
  String fecha;

  Deposito(
    this.id,
    this.asunto,
    this.monto,
    this.foto,
    this.fecha,
  );

  Deposito.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        asunto = json['asunto'],
        monto = json['monto'].toString(),
        foto = json['foto'].toString(),
        fecha = json['fecha'].toString();
}
