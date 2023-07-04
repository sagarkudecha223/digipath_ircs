class PatientOrderSetbyCitizeModel {
  final String encounterIDF;
  final String encounterDate;
  final String encounterNumber;
  final String careProfessionalIDP;
  final String doctorName;
  final String citizenIDP;
  final String careProviderIDP;
  final String careProviderName;
  final String specialityType;

  PatientOrderSetbyCitizeModel({required this.encounterIDF,
    required this.encounterDate,
    required this.encounterNumber,
    required this.careProfessionalIDP,
    required this.doctorName,
    required this.citizenIDP,
    required this.careProviderIDP,
    required this.careProviderName,
    required this.specialityType,
  });

}

class Service {
  final String patientOrderSetIDP;
  final String orderDate;
  final String serviceIDF;
  final String serviceName;
  final String remarks;

  Service(
      {required this.patientOrderSetIDP,
        required this.orderDate,
        required this.serviceIDF,
        required this.serviceName,
        required this.remarks});

}