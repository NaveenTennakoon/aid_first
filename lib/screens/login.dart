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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Center(
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
        Image.asset('assets/logo.png'),
        SizedBox(height: 50.0),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.black45),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          onChanged: (value) => _email = value.trim(),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          autofocus: false,
          obscureText: _obscureText,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.black45),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          onChanged: (value) => _password = value.trim(),
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            onPressed: () {
              signIn(_email, _password);
            },
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text(
              'Log In', 
              style: TextStyle(color: Colors.white)
            ),
          ),
        ),
        // FlatButton(
        //   child: Text(
        //     'Forgot password?',
        //     style: TextStyle(color: Colors.black54),
        //   ),
        //   onPressed: () {

        //   },
        // ),
        // FlatButton(
        //   onPressed: () {
            
        //   },
        //   child: Text('Not a member? Sign up now',
        //       style: TextStyle(color: Colors.black54)),
        // ),
      ],
    );
  }
}
