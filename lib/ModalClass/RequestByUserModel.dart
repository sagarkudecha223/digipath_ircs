class RequestByUserModel {
  late List<Data> data;
  late bool status;

  RequestByUserModel({required this.data, required this.status});

  RequestByUserModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['status'] = status;
    return data;
  }
}

class Data {
  late String patientEnquiryIDP;
  late String enquiryDate;
  late String enquiryTypeIDF;
  late String enquiryType;
  late String citizenName;
  late String contactNumber;
  late String enquiryText;
  late String cityName;
  late String closedDateTime;
  late String closedReason;
  late bool isClosed;

  Data(
      {required this.patientEnquiryIDP,
        required this.enquiryDate,
        required this.enquiryTypeIDF,
        required this.enquiryType,
        required this.citizenName,
        required this.contactNumber,
        required this.enquiryText,
        required this.cityName,
        required this.closedDateTime,
        required this.closedReason,
        required this.isClosed});

  Data.fromJson(Map<String, dynamic> json) {
    patientEnquiryIDP = json['PatientEnquiryIDP'];
    enquiryDate = json['EnquiryDate'];
    enquiryTypeIDF = json['EnquiryTypeIDF'];
    enquiryType = json['EnquiryType'];
    citizenName = json['CitizenName'];
    contactNumber = json['ContactNumber'];
    enquiryText = json['EnquiryText'];
    cityName = json['CityName'];
    closedDateTime = json['ClosedDateTime'];
    closedReason = json['ClosedReason'];
    isClosed = json['IsClosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientEnquiryIDP'] = patientEnquiryIDP;
    data['EnquiryDate'] = enquiryDate;
    data['EnquiryTypeIDF'] = enquiryTypeIDF;
    data['EnquiryType'] = enquiryType;
    data['CitizenName'] = citizenName;
    data['ContactNumber'] = contactNumber;
    data['EnquiryText'] = enquiryText;
    data['CityName'] = cityName;
    data['ClosedDateTime'] = closedDateTime;
    data['ClosedReason'] = closedReason;
    data['IsClosed'] = isClosed;
    return data;
  }
}