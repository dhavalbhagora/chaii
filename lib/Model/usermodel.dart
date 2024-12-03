class UserModel {
  String? id;
  String? contact;
  String? name;
  String? address;

  UserModel({this.id, this.contact, this.name, this.address});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contact = json['contact'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contact'] = this.contact;
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
