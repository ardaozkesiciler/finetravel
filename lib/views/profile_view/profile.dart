import 'package:finetravel/pages/login_register.dart';
import 'package:finetravel/views/home_view/home.dart';
import 'package:finetravel/views/home_view/swipe_page.dart';
import 'package:finetravel/views/redirect_view/redirect.dart';
import 'package:flutter/material.dart';
import 'package:finetravel/services/auth.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData) {
          return Redirect();
        } else {
          return LoginRegisterPage();
        }
      },
    );
  }
}
