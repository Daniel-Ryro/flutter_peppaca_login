import 'dart:convert';

import '../api/http_request.dart';
import '../model/hive_manager.dart';

class ApiSignin {
  final apiService = HttpApi();
  HiveManager hiveManager = HiveManager();

  // constructor
  ApiSignin();

  Future<Map<String, dynamic>> userSignIn(
      String userName, String passWord) async {
    await hiveManager.initBox();

    final Map<String, dynamic> queryParams = {
      'Email': userName,
      'CustomerID': '', 
      'Password': passWord,
      'Language': 'en',
    };
    Map<String, dynamic> request = apiService.getRequest("SignIn",
        queryParams['Password'], queryParams['CustomerID'], 2, queryParams);

    final response = await apiService.post<Map<String, dynamic>>(request);

    // api connection fail, not 200
    if ((response == null) || (response['Status'] == "Error")) {
      return <String, dynamic>{
        "httpStatus": "Fatal",
        "httpComment": "Not Found !"
      };
    } else {
      if (response['Status'] == httpOK) {
        hiveManager.updateSignIn(
          response['Result']['CustomerID'],
          response['Result']['Language'],
          response['Result']['Country'],
          response['Result']["NumOfOrders"],
          response['Result']["NumOfMessages"],
        );
      }
      return <String, dynamic>{
        "httpStatus": response['Status'],
        "httpComment": response['Comment']
      };
    }
  }

  Future<Map<String, dynamic>> getSecureQuestions(String customerID) async {
    final Map<String, dynamic> queryParams = {
      'CustomerID': customerID,
      'Password': '',
      'Language': hiveManager.getLanguage(),
    };

    Map<String, dynamic> request = apiService.getRequest("SecureQuestion",
        queryParams['Password'], queryParams['CustomerID'], 2, queryParams);

    final response = await apiService.post<Map<String, dynamic>>(request);

    print(jsonEncode(response));

    // api connection fail, not 200
    if (response == null) {
      return <String, dynamic>{
        "httpStatus": "Fatal",
        "httpComment": "Not Found !"
      };
    } else if (response['Status'] == "Error") {
      return <String, dynamic>{
        "httpStatus": "Error",
        "httpComment": response['Comment']
      };
    } else {
      return <String, dynamic>{
        "httpStatus": response['Status'],
        "httpComment": response['Comment'],
        "SecureQ1": response['Result']['SecureQ1'],
        "AnswerQ1": response['Result']['AnswerQ1'],
        "SecureQ2": response['Result']['SecureQ2'],
        "AnswerQ2": response['Result']['AnswerQ2'],
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String userName, String passWord) async {
        await hiveManager.initBox();
    final Map<String, dynamic> queryParams = {
      'Email': userName,
      'CustomerID': hiveManager.getCustomerID(),
      'Password': passWord,
      'Language': hiveManager.getLanguage(),
    };


    Map<String, dynamic> request = apiService.getRequest("ResetPassword",
        queryParams['Password'], queryParams['CustomerID'], 2, queryParams);

    final response = await apiService.post<Map<String, dynamic>>(request);

    //print(jsonEncode(response));

    // api connection fail, not 200
    if (response == null) {
      return <String, dynamic>{
        "httpStatus": "Fatal",
        "httpComment": "Not Found !"
      };
    } else {
      return <String, dynamic>{
        "httpStatus": response['Status'],
        "httpComment": response['Comment']
      };
    }
  }

  Future<Map<String, dynamic>> setMobileLocked(
      String email, DateTime lockedDate) async {
    final Map<String, dynamic> queryParams = {
      'Email': email,
      'LockedDate': lockedDate.toIso8601String(),
      'CustomerID': hiveManager.getCustomerID(),
      'Password': '',
      'Language': hiveManager.getLanguage(),
    };

    Map<String, dynamic> request = apiService.getRequest("SetMobileLocked",
        queryParams['Password'], queryParams['CustomerID'], 2, queryParams);

    final response = await apiService.post<Map<String, dynamic>>(request);

//    print(jsonEncode(response));

    // api connection fail, not 200
    if (response == null) {
      return <String, dynamic>{
        "httpStatus": "Fatal",
        "httpComment": "Not Found !"
      };
    } else {
      return <String, dynamic>{
        "httpStatus": response['Status'],
        "httpComment": response['Comment']
      };
    }
  }
}
