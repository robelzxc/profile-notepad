import 'dart:convert' as convert;
import 'package:final_project/screens/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:final_project/api/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  var userData;

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  void _getInfo() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString("user");
    var user = convert.jsonDecode(userJson.toString());
    setState(() {
      userData = user;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 300,),
            const Text('Are you sure u want to logout?',
              style: TextStyle(
                fontSize: 20,
              ),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                    logout();
                  }, child: const Text('Logout'))
              ],
            ),
          ],
        ),
      ),
    );
  }
  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var url = 'http://10.0.2.2:8000/api/logout';
    var response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization":"Bearer $token",
          "Accept":"application/json"
        },
    );
     Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
     _showMsg('Logout Sucessfully');

  }
  _showMsg(msg) {
    final snackBar = SnackBar(
        content: Text(msg),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
