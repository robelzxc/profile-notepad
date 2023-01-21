import 'package:final_project/api/api.dart';
import 'package:final_project/forms/user_form_page.dart';
import 'package:final_project/screens/navigation_logout_page.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:final_project/widgets/login_build.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  final userinfo;

  const LoginUser({required this.userinfo, Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image(image: AssetImage('assets/logo.png')),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 30,right: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE0F7FA),
                Color(0xFFB2EBF2),
                Color(0xFF80DEEA),
                Color(0xFF4DD0E1),
                Color(0xFF26C6DA),
                Color(0xFF00BCD4),
                Color(0xFFB2EBF2),
                Color(0xFFE0F7FA),
              ]
          ),
        ),
        child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                  ),
                ),
                buildEmail(emailController),
                const SizedBox(height: 20,),
                buildPassword(passwordController),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        isLoading ? null : _login();
                      },
                      child: Text(isLoading ? 'Logging in..' : 'Login'),
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.white)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AddUser()));
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Don\'t have an Account? ',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
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

  void _login() async {
    setState(() {
      isLoading = true;
    });

    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };

    var result = await CallApi().postData(data, 'login');
    var body = convert.jsonDecode(result.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', convert.jsonEncode(body['user']));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
    } else {
      _showMsg(body['message']);
    }
    setState(() {
      isLoading = false;
    });
  }
}
