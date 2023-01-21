import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CallApi {
  final String _url = 'http://10.0.2.2:8000/api/';

  postData(data, apiUrl) async {
    final String fullUrl = _url + apiUrl + await _getToken();
    return await http.post(Uri.parse(fullUrl),
        body: convert.jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  logoutData(apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl),
      headers: {
        'Authorization': 'Bearer'
            '$token}',
        'Accept': 'application/json'
      },
    );
  }

  //HEADERS

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json; charset=UTF-8'
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  // NOTES
  addNote(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.post(
      Uri.parse(fullUrl),
      body: convert.jsonEncode(data),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json; charset=UTF-8'
      },
    );
  }
  updateData(data, apiUrl)async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.put(Uri.parse(fullUrl),
      body: convert.jsonEncode(data),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json; charset=UTF-8'
      }
    );
  }

  deleteNote(apiUrl, id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = _url + apiUrl + id;
    return await http.delete(Uri.parse(
        fullUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json; charset=UTF-8'
        }
    );
  }
}
