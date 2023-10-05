class VisitorPlasa {
  int? id;
  String? plasaName;
  String? acc;
  String? date;
  String? ageRange;
  String? gender;
  String? time;

  VisitorPlasa({
    this.id,
    this.plasaName,
    this.acc,
    this.date,
    this.time,
    this.ageRange,
    this.gender,
  });

  VisitorPlasa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plasaName = json['plasa_id'];
    acc = json['acc'].toString();
    time = json['time'].toString();
    ageRange = json['ageRange'];
    date = json['date'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plasaName'] = this.plasaName;
    data['acc'] = this.acc;
    data['time'] = this.time;
    data['ageRange'] = this.ageRange;
    data['date'] = this.date;
    data['gender'] = this.gender;
    return data;
  }
}
