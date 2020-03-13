import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:aid_first/screens/login.dart';
import 'package:aid_first/screens/home.dart';

class Auth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) return LoginPage();
          return HomePage();
        } else {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: CupertinoActivityIndicator(
                    animating: true,
                    radius: 10,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
