class Item {
  String name;
  bool buyed;

  Item({this.name, this.buyed});

  Item.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    buyed = json['buyed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['buyed'] = this.buyed;
    return data;
  }
}
