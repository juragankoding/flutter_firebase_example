import 'package:flutter/widgets.dart';

class Binatang {
  final String nama;
  final String habitat;
  final int jumlah;

  Binatang({
    @required this.nama,
    @required this.habitat,
    @required this.jumlah,
  });

  Binatang.fromJson(Map<String, Object> json)
      : this(
          nama: json["nama"] as String,
          habitat: json["habitat"] as String,
          jumlah: json["jumlah"] as int,
        );

  Map<String, Object> toJson() {
    return {
      "nama": this.nama,
      "habitat": this.habitat,
      "jumlah": this.jumlah,
    };
  }
}
