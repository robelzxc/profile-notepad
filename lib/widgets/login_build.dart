import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:final_project/forms/login_form_page.dart';

Widget buildEmail(controller){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Email',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  offset: Offset(0,2),
                )
              ]
          ),
          height: 60,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
                color: Colors.black
            ),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF00BCD4),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                    color: Colors.black
                ),
            ),
            validator: (value) {
              if (value == "") {
                return "Please enter your email";
              } else {
                return (!EmailValidator.validate(value!))
                    ? 'Incorrect Email'
                    : null;
              }
            },
          ),
      )
    ],
  );
}

Widget buildPassword(controller){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  offset: Offset(0,2),
                )
              ]
          ),
          height: 60,
          child: TextFormField(
            controller: controller,
            obscureText: true,
            style: const TextStyle(
                color: Colors.black
            ),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xFF00BCD4),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: Colors.black
                )
            ),
            validator: (value) {
              return (value == "") ? 'Please enter your password' : null;
            },
          )
      )
    ],
  );
}
Widget buildLoginBtn() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 25),
    width: double.infinity,
    child: ElevatedButton(
        child: const Text('LOGIN'),
        onPressed: () {
        },
        style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white
        )
    ),
  );
}
Widget buildSignUpBtn() {
  return GestureDetector(
    onTap: (){

    },
    child: RichText(
      text: const TextSpan(
        children: [
          TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              )
          ),
          TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          )
        ],
      ),
    ),
  );
}