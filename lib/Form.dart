import 'dart:convert';

import 'package:ensapay/BillsPage.dart';
import 'package:ensapay/Homepage.dart';
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

class FormPage extends StatefulWidget {
  final Map<String, dynamic> creance ;
   bool onError=false;
   FormPage(this.creance,this.onError);
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<FormPage> {
  Color maincolor = Color.fromRGBO(143, 148, 251, 1);
  var form;
  var listBills;
  bool _isValide = true ;
  bool _isLoading = false ;
  Map<String, dynamic>  billHeader;
  var nameCreancier;
  Client client = new Client();
  SharedPref sharedPref = new SharedPref();

  TextEditingController fieldController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getForm(widget.creance["codeCreance"]);
    this.loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var img = widget.creance["codeCreance"];
    nameCreancier =img.substring(0,img.length-4);


    return Scaffold(
      body: _isLoading ? ColorLoader3() : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeAnimation(1.2,Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('asset/images/logo.png'),
                            )),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "ENSA PAY",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'ubuntu',
                            fontSize: 25),
                      )
                    ],
                  )
                ],
              ),),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(1.4,Text(
                "Aperçu du compte",
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'avenir'),
              ),),
              SizedBox(
                height: 40,
              ),
              FadeAnimation(1.4,
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: maincolor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (client.account.solde-client.account.credit).toString() + "  MAD",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Solde actuel",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  ),
                ),),
              SizedBox(
                height: 40,
              ),


            FadeAnimation(1.6,
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       nameCreancier + " : " + widget.creance["nameCreance"],
                       style: TextStyle(
                           fontSize: 21,
                           fontWeight: FontWeight.w800,
                           fontFamily: 'avenir'),
                     ),
                     Container(
                       height: 30,
                       width: 30,
                       decoration: BoxDecoration(
                           image: DecorationImage(
                               image: AssetImage('asset/images/$nameCreancier.png'))),
                     )
                   ],
                 ),),
              SizedBox(
                height: 50,
              ),
              form==null? Container():Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    FadeAnimation(
                      1.8,
                      _isValide ? Container() :Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Center(child: Text("invalide " + this.form["label"].toString() ,style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontFamily: "avenir"

                        ),)),
                      ) ,
                    ),
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: fieldController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: form["label"],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                        1.8,
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading= true;
                            });
                            billHeader =
                              {
                                "nameCreancier":nameCreancier,
                                "genericID":fieldController.text,
                                "codeCreance":widget.creance["codeCreance"],
                                "nameCreance":widget.creance["nameCreance"]
                              };
                            print("billheader " + billHeader.toString());
                            getbills(fieldController.text, nameCreancier, widget.creance["codeCreance"]);

//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (context) => BillPage(billHeader)));
//
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
                                "Valider",
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  getbills(String genericId, String creancier, String codeCreance) async {
    String url = "https://ensapay-client-cmi-exchanger.herokuapp.com/bills/$creancier/$codeCreance/$genericId";
    print (url);
    try {
      var response = await http.get(
          url, headers: {"Accept": "application/json"});
      print(response.statusCode);
      if(response.statusCode==200){

        this.listBills = json.decode(response.body);
        if(this.listBills!=null){
          setState(() {
            _isLoading=false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BillPage(billHeader,listBills)));
        }


      }else {
        print("error in billsPage");
        setState(() {
          _isValide = false;
          _isLoading=false;
        });
      }
    } on Exception {


    }
  }

  getForm(String codeCreance) async {

    String creancier = codeCreance.substring(0,codeCreance.length-4);

    String url="https://ensapay-client-cmi-exchanger.herokuapp.com/forms/$creancier/$codeCreance";
    await http.get(url,headers: {"Accept":"application/json"})
        .then((onvalue) {

      setState(() {
        this.form = json.decode(onvalue.body);
        //print(this.form);

      });

    }).catchError((onError){
      print("form page " +onError);
    });
  }

  loadSharedPrefs() async {

    try {
      Client clientInShared = Client.fromJson(await sharedPref.read("client"));
      setState(() {
        this.client=clientInShared;

      });
    } catch (Excepetion) {
      print("withSizedBar");
      print(Excepetion.toString());
    }
  }
}
