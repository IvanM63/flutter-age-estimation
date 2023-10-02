class Visitor {
  int? id;
  int? plasa_id;
  String? acc;
  String? date;
  String? time;
  String? ageRange;
  String? gender;

  Visitor({
    this.id,
    this.plasa_id,
    this.acc,
    this.date,
    this.time,
    this.ageRange,
    this.gender,
  });

  Visitor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plasa_id = json['plasa_id'];
    acc = json['acc'].toString();
    time = json['time'].toString();
    ageRange = json['ageRange'];
    date = json['date'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plasa_id'] = this.plasa_id;
    data['acc'] = this.acc;
    data['time'] = this.time;
    data['ageRange'] = this.ageRange;
    data['date'] = this.date;
    data['gender'] = this.gender;
    return data;
  }
}
