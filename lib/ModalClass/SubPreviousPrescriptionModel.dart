class SubPreviousPrescriptionModel {
  late List<Data> data;

  SubPreviousPrescriptionModel({required this.data});

  SubPreviousPrescriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}

class Data {
  late String patientDrugIDP;
  late String drugItemIDP;
  late String drugItemMapIDF;
  late String drugName;
  late String prescribedDate;
  late String prescribedByName;
  late String dosage;
  late String dosageDays;
  late String dosageQty;
  late String rowid;
  late String formulationAbbr;
  late String diName;
  late String dosageInfoEng;
  late String dosageInfoIDP;
  late String mf;
  late String mmf;
  late String contentName;
  late String isApproved;

  Data(
      {required this.patientDrugIDP,
        required this.drugItemIDP,
        required this.drugItemMapIDF,
        required this.drugName,
        required this.prescribedDate,
        required this.prescribedByName,
        required this.dosage,
        required this.dosageDays,
        required this.dosageQty,
        required this.rowid,
        required this.formulationAbbr,
        required this.diName,
        required this.dosageInfoEng,
        required this.dosageInfoIDP,
        required this.mf,
        required this.mmf,
        required this.contentName,
        required this.isApproved});

  Data.fromJson(Map<String, dynamic> json) {
    patientDrugIDP = json['PatientDrugIDP'];
    drugItemIDP = json['DrugItemIDP'];
    drugItemMapIDF = json['DrugItemMapIDF'];
    drugName = json['drugName'];
    prescribedDate = json['PrescribedDate'];
    prescribedByName = json['prescribedByName'];
    String d = json['Dosage'];
    dosage = d.replaceAll(",", "-");
    // dosage = d;
    dosageDays = json['DosageDays'];
    dosageQty = json['DosageQty'];
    rowid = json['rowid'];
    formulationAbbr = json['FormulationAbbr'];
    diName = json['diName'];
    dosageInfoEng = json['DosageInfoEng'];
    dosageInfoIDP = json['DosageInfoIDP'];
    mf = json['mf'];
    mmf = json['mmf'];
    contentName = json['ContentName'];
    isApproved = json['IsApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PatientDrugIDP'] = patientDrugIDP;
    data['DrugItemIDP'] = drugItemIDP;
    data['DrugItemMapIDF'] = drugItemMapIDF;
    data['drugName'] = drugName;
    data['PrescribedDate'] = prescribedDate;
    data['prescribedByName'] = prescribedByName;
    data['Dosage'] = dosage;
    data['DosageDays'] = dosageDays;
    data['DosageQty'] = dosageQty;
    data['rowid'] = rowid;
    data['FormulationAbbr'] = formulationAbbr;
    data['diName'] = diName;
    data['DosageInfoEng'] = dosageInfoEng;
    data['DosageInfoIDP'] = dosageInfoIDP;
    data['mf'] = mf;
    data['mmf'] = mmf;
    data['ContentName'] = contentName;
    data['IsApproved'] = isApproved;
    return data;
  }
}