class PagosList {
  PagosList({
    required this.formaPago,
    required this.monto,
    required this.fechaPago,
    required this.fotoUrl,
    required this.fechaDeposito,
  });

  String formaPago;
  String monto;
  String fechaPago;
  String fotoUrl;
  String fechaDeposito;

  factory PagosList.fromJson(Map<String, dynamic> json) => PagosList(
        formaPago: json["forma_pago"],
        monto: json["monto"].toString(),
        fechaPago: json["fecha_pago"].toString(),
        fotoUrl: json["foto_url"],
        fechaDeposito: json["fecha_deposito"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "forma_pago": formaPago,
        "monto": monto,
        "fecha_pago": fechaPago,
        "foto_url": fotoUrl,
        "fecha_deposito": fechaDeposito,
      };
}
