class Menuitem {
  String? id;
  String? menuname;
  String? menuprice;

  Menuitem({this.id, this.menuname, this.menuprice});

  Menuitem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuname = json['menuname'];
    menuprice = json['menuprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menuname'] = this.menuname;
    data['menuprice'] = this.menuprice;
    return data;
  }
}
