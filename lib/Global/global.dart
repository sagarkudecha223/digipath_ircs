library app.globals;
import 'package:shared_preferences/shared_preferences.dart';
import '../ModalClass/MultiAccountModal.dart';
import '../ModalClass/PathologyPackageModal.dart';
import '../ModalClass/PathologyServiceModal.dart';
import 'SearchAPI.dart';

String urlForCOM = 'https://medicodb.com';
String urlForIN = 'https://medicodb.in';
String urlForINSC = 'https://smarthealth.care';
bool loggedIn = false;
bool isOnline = false;
String internetStatus = 'ConnectivityResult.none';
String localCitizenIDP = '';
String localUserName = '';
String localUserLoginIDP = '';
String localMobileNum = '';
String localCitizenCode = '';
String careProviderID = '4286';
String TreatingDoctorIDP = '14890_1376';

String token = 'eyJhbGciOiJSUzI1NiJ9.eyJ1bmFtZSI6IjI2MDk3MTQ1NDA5MSIsInNlc3Npb25pZCI6IkQyN0I4QTBBQzNERjZCQzlEQUEwNUU2NTlDODk2NTk1Iiwic3ViIjoiSldUX1RPS0VOIiwianRpIjoiNWQxYWU3ZmYtMzJhOC00YWYxLWE4OTItODE1MWRiMDRlNzE3IiwiaWF0IjoxNjc4MTcyMTQzfQ.J4pK2XBzMaZNlgGAFxB1yFLUJoWKhzqHBKJbZfxwau7aBhMyb1ovWevVVgHQR5DsKJUhPbedNnhqvSOdLNO6uWn2qEwlGVpsslDCz1oftzA3NymnUF5xRoYoTkqjcM_3Raw6sVST9jAlw0hKmS_1tVJKBWdI1754FC-1o2qZ0mPOn-AT_1DGhWkFg88FRdtZAD2Zb7NUJ0vmvVlXzvkvhFEZsb-NksM4neAtWozUGqV-ZQ23JI21QDEZIC6Xj3khEJqNwVxNUrXH6CAdDU2QiDc7RJ6aN9HdqEdRvUSnvjA88qjBtQeNgp88rMMQ5g36WlzO0vQO4uO-Ek4pax9rpg';
String collectionType = 'Home Collection';

String ULID = '';
String mobile = '';
String citizenID = '';

String vcgroupIDP = '';
String roomName = '';

List<PathologyServiceModal> serviceList = <PathologyServiceModal>[];
List<PathologyServiceModal> selectedServiceList = <PathologyServiceModal>[];
List demoList = [];
List<PathologyServiceModal> serviceFilterList = <PathologyServiceModal>[];
List<PathologyServiceModal> trueServiceList = <PathologyServiceModal>[];
List<PathologyServiceModal> finalSelectedPackageList = <PathologyServiceModal>[];

List<PathologyPackageModal> totalPackageList = <PathologyPackageModal>[];

List<MultiAccountModal> accountList = <MultiAccountModal>[];

void updateVcGroup(String vcgroupID) async{

 dynamic status = await searchAPI(false ,'$urlForINSC/updateVcGroup.shc?vcgroupID=$vcgroupID',
      {'token' : token},{},50);

  print(' status after responce: ${status['status']}');

  if(status['status']== true){
   SharedPreferences preferences = await SharedPreferences.getInstance();
   isOnline = false;
   preferences.setBool('isOnline', false);
   preferences.setString('vcgroupID', '');
   print('isOnline ::: $isOnline');
  }else{
   print('enter in else isOnline ::: $isOnline');
  }

}