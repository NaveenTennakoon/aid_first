import 'package:flutter/material.dart';
import 'package:aid_first/auth/authentication.dart';
import 'package:aid_first/screens/anonymous.dart';

void main() => runApp(
  new MaterialApp(
      debugShowCheckedModeBanner: false,    // Temporary code for debug mode
      home : new Auth(),
      routes: {
        '/anonymous': (BuildContext context) => AnonymousPage() 
      },
    )
);
