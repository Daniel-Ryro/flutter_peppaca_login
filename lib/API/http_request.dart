import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

const String httpOK = "Success";

class HttpApi {
  final String baseUrl =
      'http://www.peppaca.website/api_v2/index/account'; // index has no meaningful action

  Future<T?> get<T>(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse<T>(response);
  }

  Future<T?> post<T>(dynamic data) async {
    final http.Response response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return _handleResponse<T>(response);
  }

  T? _handleResponse<T>(http.Response response) {
    if (response.statusCode == 200) {
      print(response);
      final dynamic jsonResponse = jsonDecode(response.body);
      return jsonResponse as T;
    } else {
      return null;
    }
  }

  Map<String, dynamic> getRequest(String action, String secretKey,
      String customerid, int apiVersion, Map<String, dynamic> params) {
    print('Received customerID: $customerid');
    String secret = secretKey == '' ? customerid : secretKey;
    String signature = _calculateHMAC(action, secret);

    return {
      "Action": action,
      "CustomerID": customerid,
      "SignatureVersion": apiVersion,
      "Signature": signature,
      "Request": params,
    };
  }

  String _calculateHMAC(String action, String secretKey) {
    var hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
    var digest = hmacSha256.convert(utf8.encode(action));
    var signature = _base64Encode(digest.toString());

    return signature;
  }

  String _base64Encode(String input) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(input);
    return encoded;
  }
}
