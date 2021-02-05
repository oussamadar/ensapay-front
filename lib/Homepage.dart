import 'dart:convert';

import 'package:ensapay/Model/SharedPref.dart';
import 'package:ensapay/Form.dart';
import 'package:ensapay/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Model/Client.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Color maincolor = Color.fromRGBO(143, 148, 251, 1);
  Color secondColor = Color(0xffffac30);
  var creancierData;
  SharedPref sharedPref = new SharedPref();
  Client client;
  List<dynamic> transactions;


  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    this.getCreanciers();
     this.loadSharedPrefs();
     this.getTransactionsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return creancierData != null && transactions!=null  ?   Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Aperçu du compte",
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'avenir'),
              ),
              SizedBox(
                height: 10,
              ),
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
                          (client.account.solde - client.account.credit)
                              .toString() + "  MAD",
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
              ),
              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Services",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'avenir'),
                  ),
//                Container(
//                  height: 30,
//                  width: 30,
//                  decoration: BoxDecoration(
//                      image: DecorationImage(
//                          image: AssetImage('asset/images/historique-des-transactions.png')
//                      )
//                  ),
//                )
                ],
              ),
              Container(
                height: 150,


                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: this.creancierData.length,
                  itemBuilder: (context, index) {
                    return avatarWidget(this.creancierData[index]);
                  },
                ),
              ),
//
//            SingleChildScrollView(
//              scrollDirection: Axis.horizontal,
//              child: Row(
//                children: [
//
//                  avatarWidget("lydec", "lydec"),
//                  avatarWidget("inwi", "Inwi"),
//                  avatarWidget("iam", "Maroc telecom"),
//
//                ],
//              ),
//            ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Historiques',
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
                            image: AssetImage(
                                'asset/images/historique-des-transactions.png'))),
                  )
                ],
              ),
//
              Expanded(
                //scrollDirection: Axis.vertical,
                child: ListView.builder(
                  itemCount: transactions.length,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 76,
                      margin: EdgeInsets.only(bottom: 13),
                      padding: EdgeInsets.only(
                          left: 24, top: 12, bottom: 12, right: 22),
                      decoration: BoxDecoration(
                        color: Color(0xfff1f3f6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 57,
                                width: 57,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "asset/images/${transactions[index]["creancier"]}.png"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    transactions[index]["creancier"],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                      this
                                          .transactions[index]["bill"]["payedDate"]
                                          .substring(0, 10),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                transactions[index]["bill"]["amount"].toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ):ColorLoader3();
  }

  Column serviceWidget(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/$img.png'))),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'avenir',
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  InkWell avatarWidget(var creancier) {
    String img = creancier['nameCreancier'];
    String nameCreancier = creancier['nameCreancier'];
    return InkWell(
      onTap: () {
        _bottomDetails(creancier);
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 100,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color(0xfff1f3f6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage('asset/images/$img.png'),
                      fit: BoxFit.contain),
                  border: Border.all(color: Colors.white, width: 2)),
            ),
            Text(
              nameCreancier
              ,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w700),
            ),

          ],
        ),
      ),
    );
  }

  getCreanciers() async {
    String url = "https://ensapay-client-cmi-exchanger.herokuapp.com/creancier/all";
    var response = await http.get(url, headers: {"Accept": "application/json"})
        .then((onvalue) {
      setState(() {
        this.creancierData = json.decode(onvalue.body);
      });
    }).catchError((onError) {
      print(onError);
      print("getCreanciers");
    });
  }

  void _bottomDetails(var creancier) {
    showModalBottomSheet(context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .canvasColor,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0)),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0)),
                        image: DecorationImage(
                            image: AssetImage('asset/images/sideImg.png'),
                            fit: BoxFit.cover
                        )),

                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                    child: Container(

                        child: new ListView(children: new List.generate(
                            creancier["listCreances"].length, (index) =>
                        new ListTile(
                          title: Text("payer vos factures " +
                              creancier["listCreances"][index]["nameCreance"]),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'asset/images/${creancier["listCreances"][index]["codeCreance"]}.png'),
                                )
                            ),

                          ),
                          onTap: () {
                            Map<String,
                                dynamic> mapCreance = creancier["listCreances"][index];
                            print(mapCreance);

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    FormPage(mapCreance, false)));
                          },
                        )),)

                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  SharedPref pref = new SharedPref();

  loadSharedPrefs() async {
    try {
      Client clientInShared = Client.fromJson(await sharedPref.read("client"));
      setState(() {
        this.client = clientInShared;
        print(client);
      });
    } catch (Excepetion) {
      print("withSizedBar");
      print(Excepetion.toString());
    }
  }

  getTransactionsHistory() async {
     client = await Client.fromJson(await sharedPref.read("client"));
    String url = "https://ensaspay-zuul-gateway.herokuapp.com/api/account/history/${client.account.id}";
    var jsonResponse;

    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer ${client.token}",
    }).then((value) {
      print(value.statusCode);
      if (value.statusCode == 200) {

        jsonResponse = json.decode(value.body);
        print(jsonResponse);
        setState(() {
          this.transactions = jsonResponse;
        });


      }
    }).catchError((onError) {
      print("transactions error" +onError.toString());
    });
  }
  orderList(List transactions){

//    transactions.sort((a,b){
//      return a.value["bill"]["payedDate"].toString()
//    });
    var nlist = transactions;
    var compare = (b, a) => a.compareTo(b);
    nlist.sort(compare);
    print(nlist);
  }
}


