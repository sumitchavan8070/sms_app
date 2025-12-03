class GetStudentsByClassModel {
  GetStudentsByClassModel({
      this.status, 
      this.message, 
      this.date, 
      this.totalStudents, 
      this.presentStudents, 
      this.absentStudents, 
      this.leaveStudents, 
      this.result,});

  GetStudentsByClassModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    date = json['date'];
    totalStudents = json['totalStudents'];
    presentStudents = json['presentStudents'];
    absentStudents = json['absentStudents'];
    leaveStudents = json['leaveStudents'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
  }
  num? status;
  String? message;
  String? date;
  num? totalStudents;
  num? presentStudents;
  num? absentStudents;
  num? leaveStudents;
  List<Result>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['date'] = date;
    map['totalStudents'] = totalStudents;
    map['presentStudents'] = presentStudents;
    map['absentStudents'] = absentStudents;
    map['leaveStudents'] = leaveStudents;
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Result {
  Result({
      this.studentId, 
      this.className, 
      this.rollNumber, 
      this.studentName, 
      this.gender, 
      this.dob, 
      this.address, 
      this.attendanceStatus, 
      this.attendanceRemarks, 
      this.attendanceDate,});

  Result.fromJson(dynamic json) {
    studentId = json['student_id'];
    className = json['class_name'];
    rollNumber = json['roll_number'];
    studentName = json['student_name'];
    gender = json['gender'];
    dob = json['dob'];
    address = json['address'];
    attendanceStatus = json['attendance_status'];
    attendanceRemarks = json['attendance_remarks'];
    attendanceDate = json['attendance_date'];
  }
  num? studentId;
  String? className;
  num? rollNumber;
  String? studentName;
  String? gender;
  String? dob;
  String? address;
  String? attendanceStatus;
  String? attendanceRemarks;
  String? attendanceDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['student_id'] = studentId;
    map['class_name'] = className;
    map['roll_number'] = rollNumber;
    map['student_name'] = studentName;
    map['gender'] = gender;
    map['dob'] = dob;
    map['address'] = address;
    map['attendance_status'] = attendanceStatus;
    map['attendance_remarks'] = attendanceRemarks;
    map['attendance_date'] = attendanceDate;
    return map;
  }

}