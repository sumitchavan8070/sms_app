class ClientLoginModel {
  ClientLoginModel({this.status, this.accessToken, this.user});

  ClientLoginModel.fromJson(dynamic json) {
    status = json['status'];
    accessToken = json['access_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  num? status;
  String? accessToken;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['access_token'] = accessToken;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class User {
  User({this.id, this.firstName, this.lastName, this.email, this.role, this.school});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    school = json['school'] != null ? School.fromJson(json['school']) : null;
  }

  num? id;
  String? firstName;
  String? lastName;
  String? email;
  Role? role;
  School? school;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    if (role != null) {
      map['role'] = role?.toJson();
    }
    if (school != null) {
      map['school'] = school?.toJson();
    }
    return map;
  }
}

class School {
  School({
    this.id,
    this.name,
    this.code,
    this.address,
    this.phone,
    this.email,
    this.principalName,
    this.establishedYear,
    this.status,
    this.createdAt,
  });

  School.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    principalName = json['principalName'];
    establishedYear = json['establishedYear'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  num? id;
  String? name;
  String? code;
  String? address;
  String? phone;
  String? email;
  String? principalName;
  num? establishedYear;
  String? status;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['address'] = address;
    map['phone'] = phone;
    map['email'] = email;
    map['principalName'] = principalName;
    map['establishedYear'] = establishedYear;
    map['status'] = status;
    map['createdAt'] = createdAt;
    return map;
  }
}

class Role {
  Role({this.id, this.name});

  Role.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  num? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
