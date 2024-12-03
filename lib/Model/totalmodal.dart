class total {
  String? id;
  String? total_sum;

  total({this.id, this.total_sum});

  total.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total_sum = json['total_sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_sum'] = this.total_sum;
    return data;
  }
}
