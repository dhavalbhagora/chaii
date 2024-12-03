class BillModal {
  String? id;
  String? amount;
  String? date;
  String? name;
  String? time;
  String? status;
  String? shopid;

  BillModal(
      {this.id,
      this.amount,
      this.date,
      this.name,
      this.time,
      this.status,
      this.shopid});

  BillModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    name = json['name'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    shopid = json['shopid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['name'] = this.name;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['shopid'] = this.shopid;

    return data;
  }
}
