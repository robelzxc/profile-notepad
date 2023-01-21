import 'package:final_project/api/api.dart';
import 'package:final_project/screens/navigation_logout_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();

  bool _isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: nameController,
              validator: (value) {
                return (value == '') ? 'Please enter your name' : null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
                hintText: "Enter Full name",
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == '') {
                  return 'Please enter your email address';
                } else {
                  return (!EmailValidator.validate(value!))
                      ? 'Invalid Email Address'
                      : null;
                }
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Ex. mondejarhoneylee16@gmail.com',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white70,
                  ),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              obscureText: isPasswordVisible ? false : true,
              controller: passwordController,
              validator: (value) {
                return (value == '') ? 'Please enter your password' : null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Ex. Honeylee!',
                prefixIcon: const Icon(Icons.lock,
                    color: Colors.white70, size: 22),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              obscureText: isConfirmPasswordVisible ? false : true,
              controller: confirmationController,
              validator: (value) {
                return (value != passwordController.value.text)
                    ? 'Password dont match'
                    : null;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Ex. Honeylee!',
                prefixIcon: const Icon(Icons.lock,
                    color: Colors.white70, size: 22),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                  child: Icon(
                    isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
                onTap: () {
                  var isFormValid = formKey.currentState!.validate();
                  if (isFormValid) {
                    _isLoading ? null : _handleLogin();
                  }
                },
                child: Container(
                  height: 53,
                  width: 250,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black12.withOpacity(.2),
                            offset: const Offset(2, 2))
                      ],
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(colors: [
                        Colors.cyan.shade100,
                        Colors.cyan.shade800,
                      ])
                    // color: Colors.cyan.shade100,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.black12.withOpacity(.6),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': confirmationController.text,
    };

    var result = await CallApi().postData(data, 'register');
    var body = convert.jsonDecode(result.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', convert.jsonEncode(body['user']));

      Navigator.push(context, MaterialPageRoute(builder: (context)=> NavigationPage()));
    }
    setState(() {
      _isLoading = true;
    });
  }
}
