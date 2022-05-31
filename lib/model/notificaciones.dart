class Notificacioes {
  Notificacioes({
    required this.titulo,
    required this.mensaje,
    required this.imagen,
    required this.fecha,
  });

  String titulo;
  String mensaje;
  String imagen;
  String fecha;

  factory Notificacioes.fromJson(Map<String, dynamic> json) => Notificacioes(
        titulo: json["titulo"],
        mensaje: json["mensaje"],
        imagen: json["imagen"].toString(),
        fecha: json["fecha"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "mensaje": mensaje,
        "imagen": imagen.toString(),
        "fecha": fecha.toString(),
      };
}
