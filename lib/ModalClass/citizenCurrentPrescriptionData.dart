class citizenCurrentPrescriptionData {
  late final String EncounterID;
  late final String DoctorName;
  late final String PrescribedDate;
  late final String FacultyName;
  late final String CareProviderName;

  citizenCurrentPrescriptionData(
      {required this.EncounterID,
        required this.DoctorName,
        required this.PrescribedDate,
        required this.FacultyName,
        required this.CareProviderName});

  citizenCurrentPrescriptionData.fromJson(Map<String, dynamic> json) {
    EncounterID = json['EncounterID'];
    DoctorName = json['DoctorName'];
    PrescribedDate = json['PrescribedDate'];
    FacultyName = json['FacultyName'];
    CareProviderName = json['CareProviderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EncounterID'] = EncounterID;
    data['DoctorName'] = DoctorName;
    data['PrescribedDate'] = PrescribedDate;
    data['FacultyName'] = FacultyName;
    data['CareProviderName'] = CareProviderName;
    return data;
  }
}