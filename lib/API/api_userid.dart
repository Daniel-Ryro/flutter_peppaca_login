import '../api/http_request.dart';
import '../model/hive_manager.dart';

class ApiUserid {
  final String customerid;
  final String language;
  final apiService = HttpApi();
  HiveManager hiveManager = HiveManager();

  // constructor
  ApiUserid(this.customerid, this.language);

  Future<Map<String, dynamic>> confirmUser() async {
    final Map<String, dynamic> queryParams = {'customerid': customerid};
    final Map<String, dynamic> queryRequest = {
      'Language': language,
    };

    Map<String, dynamic> request = apiService.getRequest("Userid",
        queryParams['customerid'], queryParams['customerid'], 2, queryRequest);

    final response = await apiService.post<Map<String, dynamic>>(request);

    // api connection fail, not 200
    if ((response == null) || (response['Status'] == "Error")) {
      return <String, dynamic>{
        "httpStatus": "Fatal",
        "httpComment": "Not Found !"
      };
    } else {
      if (response['Status'] == httpOK) {
        hiveManager.updateUserID(
            response['Result']['Language'], response['Result']['Country']);
      }

      return <String, dynamic>{
        "httpStatus": response['Status'],
        "httpComment": response['Comment'],
        "mobileLocked": response['Result']['MobileLocked'] == null
            ? null
            : DateTime.parse(response['Result']['MobileLocked']),
      };
    }
  }
}
