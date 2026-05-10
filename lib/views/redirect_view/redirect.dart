import 'package:finetravel/services/auth.dart';
import 'package:flutter/material.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    Auth authService = Auth();
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              await authService.signOut();
            },
            child: Text('Cikis yap'),
          ),
        ],
      ),
      body: Center(child: Text('Redirect')),
    );
  }
}
