import 'dart:io';

class Plasa {
  int? id;
  String? name;
  String? jalan;
  String? kecamatan;
  String? kota;
  String? pengunjung = '0';
  String? image;

  Plasa({
    this.id,
    this.name,
    this.jalan,
    this.kecamatan,
    this.kota,
    this.pengunjung,
    this.image,
  });

  Plasa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    jalan = json['jalan'].toString();
    kecamatan = json['kecamatan'];
    kota = json['kota'];
    pengunjung = json['pengunjung'].toString();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['jalan'] = this.jalan;
    data['kecamatan'] = this.kecamatan;
    data['kota'] = this.kota;
    data['pengunjung'] = this.pengunjung;
    data['image'] = this.image;

    return data;
  }
}
