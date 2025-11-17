class NotificationModel {
  int? id;
  String? title;
  String? body;
  String? createdDate;

  NotificationModel({this.id, this.title, this.body, this.createdDate});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
