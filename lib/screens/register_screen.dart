import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../bloc/bloc.dart';
import 'home.dart';
import 'package:connectivity/connectivity.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email,password;
  String category = 'football';
  final bloc = Bloc();
  //-------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Register",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Builder(
          builder: (context) => ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: <Widget>[
                  Image(
                    image: AssetImage('images/TikTok.png'),
                    height: 250,
                    width: 200,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  //------------------------------
                  Text('What Category you prefer?',style: TextStyle(color: Colors.blueAccent,fontSize: 20),),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownButton<String>(
                    style: TextStyle(color: Colors.black),
                    isExpanded: true,
                    hint: Text('chooose'),
                    value: category,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        category = newValue;
                      });
                    },
                    items: <String>['football', 'funny','animals','music']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  //------------------------------
                  StreamBuilder<String>(
                    stream: bloc.email,
                    builder: (context, snapshot) => TextField(
                      style: TextStyle(color: Colors.black),
                      onChanged: bloc.emailChanged,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter email",
                          labelText: "Email",
                          errorText: snapshot.error),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  StreamBuilder<String>(
                    stream: bloc.password,
                    builder: (context, snapshot) => TextField(
                      style: TextStyle(color: Colors.black),
                      onChanged: bloc.passwordChanged,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter password",
                          labelText: "Password",
                          errorText: snapshot.error),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RoundedButton(
                    title: 'Register',
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: bloc.getEmail,
                                password: bloc.getPassword);
                        //---------------------------------------
                        final FirebaseUser user = await _auth.currentUser();
                        final uid = user.uid;
                        await _fireStore.collection('users').add({
                          'id': uid,
                          'category': category,
                        });
                        //---------------------------------------
                        if ((newUser != null) ||
                            (connectivityResult == ConnectivityResult.mobile) ||
                            (connectivityResult == ConnectivityResult.wifi)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );

                        }
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        if (e is PlatformException) {
                          if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              content: Text("Email alredy exists !"),
                            ));
                          } else {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              content: Text("Please enter email and passowrd"),
                            ));
                          }
                        }
                        if ((connectivityResult != ConnectivityResult.mobile) &&
                            (connectivityResult != ConnectivityResult.wifi)) {
                          setState(() {
                            showSpinner = false;
                          });
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            backgroundColor: Colors.black,
                            duration: Duration(seconds: 3),
                            content: Text(
                              "No internet Connection !",
                              style: TextStyle(fontSize: 17),
                            ),
                          ));
                        } else if (bloc.getEmail == null ||
                            bloc.getPassword == null) {
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                            content: Text(
                              "Please, Enter email and passowrd!",
                              style: TextStyle(fontSize: 17),
                            ),
                          ));
                        }
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                ],
              )),
        ));
  }
}
