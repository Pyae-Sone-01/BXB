class ForceUpdateResponseModel {
  String? url;
  String? details;

  ForceUpdateResponseModel({this.url, this.details});

  ForceUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['details'] = this.details;
    return data;
  }
}
