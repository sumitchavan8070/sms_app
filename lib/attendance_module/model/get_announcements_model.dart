class GetAnnouncementsModel {
  GetAnnouncementsModel({
      this.status, 
      this.message, 
      this.data,});

  GetAnnouncementsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  num? status;
  String? message;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.title, 
      this.message, 
      this.audience, 
      this.postedBy, 
      this.postedOn, 
      this.schoolId, 
      this.schoolName,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    audience = json['audience'];
    postedBy = json['postedBy'] != null ? PostedBy.fromJson(json['postedBy']) : null;
    postedOn = json['postedOn'];
    schoolId = json['schoolId'];
    schoolName = json['schoolName'];
  }
  num? id;
  String? title;
  String? message;
  String? audience;
  PostedBy? postedBy;
  String? postedOn;
  num? schoolId;
  String? schoolName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['message'] = message;
    map['audience'] = audience;
    if (postedBy != null) {
      map['postedBy'] = postedBy?.toJson();
    }
    map['postedOn'] = postedOn;
    map['schoolId'] = schoolId;
    map['schoolName'] = schoolName;
    return map;
  }

}

class PostedBy {
  PostedBy({
      this.id, 
      this.username, 
      this.email,});

  PostedBy.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
  }
  num? id;
  String? username;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    return map;
  }

}