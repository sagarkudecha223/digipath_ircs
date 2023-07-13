class PaymentModal{

  final String encounterIDP;
  final String purposeType;
  final String encounterDate;
  final String amount;
  final String collecationTime;
  final String StartTimeSlot;
  final bool isPay;

  PaymentModal({

    required this.encounterIDP,
    required this.purposeType,
    required this.encounterDate,
    required this.amount,
    required this.collecationTime,
    required this.StartTimeSlot,
    required this.isPay,

  });
}

class PaidPaymentModal{

  final String voucherIDP;
  final String voucherTypeIDP;
  final String voucherDate;
  final String tDr;
  final String amount;
  final String episodeID;
  final String patientProfileID;

  PaidPaymentModal({
   required this.voucherIDP,
   required this.voucherTypeIDP,
   required this.voucherDate,
   required this.tDr,
   required this.amount,
   required this.episodeID,
   required this.patientProfileID
  });

}