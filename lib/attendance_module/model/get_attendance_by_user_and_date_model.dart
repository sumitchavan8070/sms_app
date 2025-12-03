  class GetAttendanceByUserAndDateModel {
  GetAttendanceByUserAndDateModel({this.status, this.message, this.data});

  GetAttendanceByUserAndDateModel.fromJson(dynamic json) {
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
    this.date,
    this.status,
    this.studentId,
    this.studentName,
    this.className,
    this.rollNumber,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    status = json['status'];
    studentId = json['student_id'];
    studentName = json['student_name'];
    className = json['class_name'];
    rollNumber = json['roll_number'];
  }

  num? id;
  String? date;
  String? status;
  num? studentId;
  String? studentName;
  String? className;
  num? rollNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['status'] = status;
    map['student_id'] = studentId;
    map['student_name'] = studentName;
    map['class_name'] = className;
    map['roll_number'] = rollNumber;
    return map;
  }
}
