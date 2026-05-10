import 'package:finetravel/services/auth.dart';
import 'package:finetravel/views/favorites_view/favorites.dart';
import 'package:finetravel/views/home_view/swipe_page.dart';
import 'package:finetravel/views/redirect_view/redirect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorMessage;
  bool isLogin = true;

  void showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message'),
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> createUser() async {
    try {
      await Auth().createUser(
        email: emailController.text,
        password: passwordController.text,
      );

      //Navigator.push(
      //context,
      //MaterialPageRoute(
      //builder: (context) {
      //return const Redirect();
      //},
      //),
      //);

      showMessage('Hesap olusturuldu!', false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });

      showMessage('Hesap olusturulamadi', true);
    }
  }

  Future<void> signIn() async {
    try {
      await Auth().signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      //Navigator.push(
      //context,
      //MaterialPageRoute(
      //builder: (context) {
      //return const Redirect();
      //},
      //),
      //);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Redirect()),
        (route) => false,
      );

      showMessage('Giris Basarili!', false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      showMessage('Giris Basarisiz!', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),

            errorMessage != null
                ? Text(errorMessage!)
                : const SizedBox.shrink(),
            ElevatedButton(
              onPressed: () {
                if (isLogin) {
                  signIn();
                } else {
                  createUser();
                }
              },
              child: isLogin ? const Text('Login') : const Text('Register'),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text('Henuz hesabin yok mu? Tikla'),
            ),
          ],
        ),
      ),
    );
  }
}
