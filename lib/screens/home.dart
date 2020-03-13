import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<Null> _signout () async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AID FIRST'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person), 
            onPressed: () {
              _signout();
            }
          ),
        ],
      ),
    );
  }
}
