import 'dart:convert';

import 'package:bits_hackathon/global%20widgets/buttons.dart';
import 'package:bits_hackathon/global%20widgets/searchbar.dart';
import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/homepage/FirstScreen.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final numberplate = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  bool isRegister = true;

  Future<void> setSession(Map<String, dynamic> token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', jsonEncode(token));
    print("In the set session");
  //  final temp =  setSession({"data":"the ses"});
    // print(temp);
  }

   Future<String?> getSession() async {
    print("infffffffffffffffffffffffff");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_token');
  }

   void getgetsession() async {
   
    final s = await getSession();
   
 
    token = json.decode(s ?? '{"data":"none"}');
    print('The Live Session: $token');
    
    // token = {"data":"user"};
  }

  void register(String nameText,String emailText, String passwordText, String phNo) async {
      try{
      final Map<String, dynamic> jsonData = {
        'name': nameText,
        'email': emailText,
        'password': passwordText,
        'phNo': phNo
      };
        final res = await http.post(
        Uri.parse("https://node-api-5kc9.onrender.com/register"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData), // Encode the Map to JSON
      );

      if(res.statusCode == 200){
        print(res.body);

     
        final apiRes = json.decode(res.body);
        setSession(apiRes);
        getgetsession();
  //set alert here
      Navigator.of(context).pop();
      }

      }catch(err){
          print(err);

      }
  }



  void login(String emailText, String passwordText) async {

       try{
      final Map<String, dynamic> jsonData = {
        
        'email': emailText,
        'password': passwordText,
     
      };
        final res = await http.post(
        Uri.parse("https://node-api-5kc9.onrender.com/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData), // Encode the Map to JSON
      );

      if(res.statusCode == 200){
        print(res.body);

     
        final apiRes = json.decode(res.body);
        setSession(apiRes);
        getgetsession();
          Navigator.pushReplacement(context,
                     MaterialPageRoute(builder: (context) {
                      return const FirstScreen();
           }));

           Fluttertoast.showToast(
          
          msg: "Logged in successfully",
          timeInSecForIosWeb: 5,
          backgroundColor: const Color.fromARGB(255, 112, 234, 116),
          webBgColor: "green",
          textColor: Colors.white);
        

      }

      }catch(err){
          print(err);

      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegister ? "Register" : "Login"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Visibility(
            visible: isRegister,
            child:     CustomTextField(
            controller: name,
            hint: "name",
            icon: Icons.person_2_outlined,
          ),
          ),
      
          CustomTextField(
            controller: email,
            hint: "email",
            icon: Icons.email,
          ),
          CustomTextField(
            controller: password,
            hint: "Password",
            icon: Icons.password,
            ispassword: true,
          ),
          Visibility(
            visible: isRegister,
            child: CustomTextField(
              controller: numberplate,
              hint: "Number Plate (optional)",
              icon: Icons.car_crash_rounded,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (isRegister) {
                register(name.text,email.text, password.text, numberplate.text);
              } else {
                login(email.text, password.text);
              }
            },
            child: ConfirmButton(
              text: isRegister ? "Register" : "Login",
            ),
          ),
          Visibility(
            visible: isRegister,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isRegister = false;
                    });
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
