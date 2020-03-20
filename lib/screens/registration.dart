import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> _key = GlobalKey();
  UserUpdateInfo profileUpdates = UserUpdateInfo();
  String _email;
  String _password;
  String _username;
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Null> signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      profileUpdates.displayName = _username;
      await user.updateProfile(profileUpdates);
    } 
    catch(error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(child: Text(error.message))
          );
        }
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/login.jpg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),     
              child: Form(
                key: _key,
                autovalidate: true,
                child: _form(),
              )
            )
          )
        )
      )
    );
  }

  Widget _form() {
    return Column(
      children: <Widget>[
        SizedBox(height: 50.0),
        Image.asset('assets/logo.png'),
        SizedBox(height: 50.0),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.black38),
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.black38)
          ),
          onChanged: (value) => _email = value.trim()
        ),
        SizedBox(height: 20.0),
        TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.black38),
            hintText: 'Username',
            hintStyle: TextStyle(color: Colors.black38)
          ),
          onChanged: (value) => _username = value.trim()
        ),
        SizedBox(height: 20.0),
        TextFormField(
          autofocus: false,
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.black38),
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.black38),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black45
              )
            )
          ),
          onChanged: (value) => _password = value.trim()
        ),
        SizedBox(height: 30.0),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            onPressed: () {
              signUp(_email, _password);
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text('Register', style: TextStyle(color: Colors.white))
          )
        ),
        SizedBox(height: 20.0),
        FlatButton(
          child: Row(
            children: <Widget>[
              Icon(Icons.arrow_back, color: Colors.black54, size: 18.0),
              Text(' back to Login', style: TextStyle(color: Colors.black54))
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          onPressed: () {
            Navigator.pop(context);
          }
        )
      ]
    );
  }
}
