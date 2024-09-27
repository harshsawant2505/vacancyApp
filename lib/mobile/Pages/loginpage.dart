import 'package:bits_hackathon/global%20widgets/buttons.dart';
import 'package:bits_hackathon/global%20widgets/searchbar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final numberplate = TextEditingController();
  final password = TextEditingController();
  bool isRegister = true;

  void register(
      String emailText, String passwordText, String numberText) async {}

  void login(String emailText, String passwordText) async {}

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
                register(email.text, password.text, numberplate.text);
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
