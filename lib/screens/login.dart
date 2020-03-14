import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = GlobalKey();
  String _email;
  String _password;
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      children: <Widget>[
        SizedBox(height: 45.0),
        Image.asset('assets/logo.png'),
        SizedBox(height: 50.0),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.black38),
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.black38),
          ),
          onChanged: (value) => _email = value.trim(),
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
                color: Colors.black45,
              ),
            ),
          ),
          onChanged: (value) => _password = value.trim(),
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            onPressed: () {
              signIn(_email, _password);
            },
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ),
        FlatButton(
          child: Text('Forgot password?', style: TextStyle(color: Colors.black54),),
          onPressed: () {
            // Forgot password implementation
          },
        ),
        FlatButton(
          onPressed: () {
            // Sign up re route
          },
          child: Text('Not a member? Sign up now', style: TextStyle(color: Colors.black54))
        ),
        Row(children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 20.0),
              child: Divider(height: 45, color: Colors.black54)
            ),
          ),
          Text(
            'OR',
            style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Divider(height: 45, color: Colors.black54)
            )
          )
        ]),
        RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          onPressed: () {
            // anonymously continue
          },
          padding: EdgeInsets.all(12),
          color: Colors.red,
          child: Text('Continue anonymously', style: TextStyle(color: Colors.white))
        )
      ]
    );
  }
}
