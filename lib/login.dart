import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  bool hiddenpassword = true;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
   String _username,_password;
   bool checktheusername = false;
  final TextEditingController usernameController =TextEditingController();
  final TextEditingController _pass = TextEditingController();

  Future Loginme() async
  {
    String _username = usernameController.text;
     String _password = _pass.text;

    var url = Uri.parse('https://arjunpoudel122.com.np/login.php?username='+_username+'&password='+_password);

    http.Response response = await http.get(url);

    if(response.statusCode==200)
    {
      String message = response.body;
      Map <String,dynamic> abc = jsonDecode(message);

      if(abc['valid']==true)
      {
        print('User is valid');
        setState(() {
          Navigator.pushNamed(context, 'login');
        });

      }
      else
      {
        return Alert(context: context,title: 'Either Your Username or Password is incorrect').show();
      }
      }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.png'), fit: BoxFit.fill,),

      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4),

          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:50,right:50),
                child: TextFormField(
                  validator: validateusername,
                  controller: usernameController,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.user,color: Colors.grey,),
                      ),
                      filled: true,
                      hintText: "username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50,right: 50),
                child: TextFormField(
                  controller: _pass,
                  validator: validatepassword,
                  keyboardType: TextInputType.name,
                  obscureText: hiddenpassword,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      suffixIcon: InkWell(
                        onTap: () {
                          password();
                        },
                        child: Icon(
                          hiddenpassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.lock,color: Colors.grey,),
                      ),
                      filled: true,

                      hintText: "PassWord",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: TextButton(
                        onPressed: () {
                          Loginme();
                              },
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                ],

              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xff4c505b),
                            fontSize: 18),
                      ),
                    ),
                    style: ButtonStyle(),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xff4c505b),
                            fontSize: 18,
                          ),
                        ),
                      )),
                ],
              )
            ],
        ),
          ),
        ),
    ),
    );

  }
  void password() {
    setState(() {
      hiddenpassword=!hiddenpassword;
    });
  }

  String validateusername(String value){
    if(value.isEmpty)
    {
      return 'Please Fill Your Username';
    }

  }
  String validatepassword(String value){
    if(value.isEmpty)
    {
      return 'Please Fill Your Password';
    }

  }
}