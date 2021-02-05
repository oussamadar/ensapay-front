import 'dart:convert';

import 'package:ensapay/Homepage.dart';
import 'package:ensapay/Model/Account.dart';
import 'package:ensapay/Model/Client.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Animation/FadeAnimation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Homepagewithsidebar.dart';

import 'Model/SharedPref.dart';
import 'loader.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

}

//final FirebaseAuth mAuth = FirebaseAuth.instance;
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  Color mainColor = Color(0xff0F8B8D);

  TextEditingController phoneController = new TextEditingController() ;
  TextEditingController passwordController = new TextEditingController() ;
  bool _isLoading = false;
  SharedPref sharedPref = new SharedPref();

  bool _isValide=false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;

    });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPref.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading? ColorLoader3():SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[

                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('asset/images/background.png'),
                              fit: BoxFit.fill)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeAnimation(
                                1,
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'asset/images/light-1.png'))),
                                )),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 150,
                            child: FadeAnimation(
                                1.3,
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'asset/images/light-2.png'))),
                                )),
                          ),
                          Positioned(
                            right: 40,
                            top: 10,
                            width: 80,
                            height: 150,
                            child: FadeAnimation(
                                1.5,
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'asset/images/mobile-payment.png'))),
                                )),
                          ),
                          Positioned(
                            child: FadeAnimation(
                                1.6,
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 80,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ENSA PAY",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[

                          _isValide ? (  badPassword()) : Container(),

                          FadeAnimation(
                              1.8,
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[100]))),
                                        child: TextFormField(
                                          controller: phoneController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Numero de telephone",
                                          ),
                                          validator: (value) {
                                            return phoneNumberValidator(value);
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[100]))),
                                        child: TextFormField(
                                          controller: passwordController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'Mot de passe',
                                          ),
                                          obscureText: _obscureText,

                                          validator: (value) {
                                            return passWordValidator(value);
                                          },
                                        ),
                                      ),
                                      new FlatButton(
                                          onPressed: _toggle,
                                          child: new Text(
                                              _obscureText ? "Show" : "Hide"))
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                              2,
                              InkWell(
                                onTap: () {
                                  // Validate returns true if the form is valid, otherwise false.
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading=true;
                                    });
                                    print(" before sign in");
                                    signIn(phoneController.text, passwordController.text);
                                    print(" after sign in");
                                  }

                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 70,
                          ),
                          FadeAnimation(
                              1.5,
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),





        );
  }

  String phoneNumberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Veuillez renseigner votre numero de telephone';
    } else if (!regExp.hasMatch(value)) {
      return 'Veuillez entrer un numero valide';
    }
    return null;
  }

  String passWordValidator(String value) {
    if (value.isEmpty) {
      return 'Veuillez renseigner votre mot de passe';
    }
    return null;
  }
  signIn(String username,String password) async  {
    print("in sign in");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String url = "https://ensaspay-zuul-gateway.herokuapp.com/oauth/token?grant_type=password&username=$username&password=$password";
    var jsonResponse;

    var response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic Y2xpZW50OnNlY3JldA==' ,
    });
    if(response.statusCode==200){

      jsonResponse = json.decode(response.body);



      if(jsonResponse !=null){
        setState(()   async {
          _isLoading = false;
          Client client = new Client();
          client.token=jsonResponse["access_token"];
          client.tel=username;
          print(jsonResponse);
           await getClientInfo(client);

             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeWithSidebar()), (Route<dynamic> route) => false);

        });
        print("---resp---");
        print(jsonResponse);
      }

    } else{
      print("statut code 400");
      setState(() {
        _isLoading=false;
        _isValide=true;
      });
      print(response.body);
    }

  }


   badPassword() {
    return
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Text("numero de telephone ou mot de passe incorrect",style: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontFamily: "ubuntu",
          fontWeight: FontWeight.w400,
        ),),

    ) ;
  }
 getClientInfo(Client client) async{
    String url = "https://ensaspay-zuul-gateway.herokuapp.com/api/client/getClient/${client.tel}";
    var jsonResponse;

    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${client.token}" ,
    }).then((value) async {
      jsonResponse=json.decode(value.body);
      if(jsonResponse!=null){

      }
      client.id=jsonResponse["id"];
      client.firstName=jsonResponse["firstName"];
      client.lastName=jsonResponse["lastName"];
      client.address=jsonResponse["address"];

      Account account = new Account();
      account.id=jsonResponse["account"]["id"];
      account.accountNumber=jsonResponse["account"]["accountNumber"];
      account.solde=jsonResponse["account"]["amount"];
      account.credit=jsonResponse["account"]["credit"];

      client.account=account;
      try{
        sharedPref.save("client", client);
        Client clientInShared = Client.fromJson(await sharedPref.read("client"));
        print(clientInShared );
        print("hi hi");

      } catch (Exception){
        print("error in save");
        print(Exception.toString());
      }
      //print(json.encode(client));
      //print(client);
    }).catchError((error){
      print(error);
      print("login");
    });
//    if(response.statusCode==200){
//      jsonResponse=json.decode(response.body);
//      client.firstName;
//      print(jsonResponse);
//    }else{
//     getClientInfo(client);
//    }

  }

}

