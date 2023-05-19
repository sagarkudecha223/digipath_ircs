class PatientOrderSetbyCitizeModel {
  late List<Data> data;
  late bool status;

  PatientOrderSetbyCitizeModel({required this.data, required this.status});

  PatientOrderSetbyCitizeModel.fromJson(Map<String, dynamic> json) {
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
  late String encounterIDF;
  late String encounterDate;
  late String encounterNumber;
  late String careProfessionalIDP;
  late String doctorName;
  late String citizenIDP;
  late String careProviderIDP;
  late String careProviderName;
  late String specialityType;
  late List<Service> service;

  Data(
      {required this.encounterIDF,
        required this.encounterDate,
        required this.encounterNumber,
        required this.careProfessionalIDP,
        required this.doctorName,
        required this.citizenIDP,
        required this.careProviderIDP,
        required this.careProviderName,
        required this.specialityType,
        required this.service});

  Data.fromJson(Map<String, dynamic> json) {
    encounterIDF = json['EncounterIDF'];
    encounterDate = json['EncounterDate'];
    encounterNumber = json['EncounterNumber'];
    careProfessionalIDP = json['CareProfessionalIDP'];
    doctorName = json['DoctorName'];
    citizenIDP = json['CitizenIDP'];
    careProviderIDP = json['CareProviderIDP'];
    careProviderName = json['CareProviderName'];
    specialityType = json['SpecialityType'];
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service.add(Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EncounterIDF'] = encounterIDF;
    data['EncounterDate'] = encounterDate;
    data['EncounterNumber'] = encounterNumber;
    data['CareProfessionalIDP'] = careProfessionalIDP;
    data['DoctorName'] = doctorName;
    data['CitizenIDP'] = citizenIDP;
    data['CareProviderIDP'] = careProviderIDP;
    data['CareProviderName'] = careProviderName;
    data['SpecialityType'] = specialityType;
    if (service != null) {
      data['service'] = service.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  late String patientOrderSetIDP;
  late String orderDate;
  late String serviceIDF;
  late String serviceName;
  late String remarks;

  Service(
      {required this.patientOrderSetIDP,
        required this.orderDate,
        required this.serviceIDF,
        required this.serviceName,
        required this.remarks});

  Service.fromJson(Map<String, dynamic> json) {
    patientOrderSetIDP = json['PatientOrderSetIDP'];
    orderDate = json['OrderDate'];
    serviceIDF = json['ServiceIDF'];
    serviceName = json['ServiceName'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientOrderSetIDP'] = patientOrderSetIDP;
    data['OrderDate'] = orderDate;
    data['ServiceIDF'] = serviceIDF;
    data['ServiceName'] = serviceName;
    data['Remarks'] = remarks;
    return data;
  }
}