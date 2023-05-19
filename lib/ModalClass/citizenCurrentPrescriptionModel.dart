import 'citizenCurrentPrescriptionData.dart';

class citizenCurrentPrescriptionModel {
  List<citizenCurrentPrescriptionData>? data;
  bool? status;

  citizenCurrentPrescriptionModel({required this.data, required this.status});

  citizenCurrentPrescriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <citizenCurrentPrescriptionData>[];
      json['data'].forEach((v) {
        data!.add(citizenCurrentPrescriptionData.fromJson(v));
      });
    }
    status = json['status'];
  }
}