class ImagenCarrusel {
  String avatarurl;

  ImagenCarrusel({required this.avatarurl});

  factory ImagenCarrusel.fromJson(Map<String, dynamic> json) => ImagenCarrusel(
        avatarurl: json["avatarurl"],
      );

  Map<String, dynamic> toJson() => {
        "avatarurl": avatarurl,
      };
}
