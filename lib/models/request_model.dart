class RequestModel {
  String floatId;
  String requestTo;
  String requestFrom;

  RequestModel({
    this.floatId,
    this.requestTo,
    this.requestFrom,
  });

  RequestModel.fromJson(Map<String, dynamic> json) {
    floatId = json['floatId'];
    requestTo = json['requestTo'];
    requestFrom = json['requestFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['floatId'] = this.floatId;
    data['requestTo'] = this.requestTo;
    data['requestFrom'] = this.requestFrom;

    return data;
  }
}
