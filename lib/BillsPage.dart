import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Animation/FadeAnimation.dart';
import 'Model/Client.dart';
import 'Model/SharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';

class BillPage extends StatefulWidget {
  final Map<String, dynamic> billHeader;
  final Map<String, dynamic> widgetListBills;
  const BillPage(this.billHeader, this.widgetListBills);

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  Color maincolor = Color.fromRGBO(143, 148, 251, 1);
  Map<String, dynamic> listBills;
  bool _isLoading = false;
  TwilioFlutter twilioFlutter;

  TextEditingController codeController = new TextEditingController();
  int codeVerification;
  bool _isCodeValide = true;

  @override
  void initState() {
    // TODO: implement initState

    this.listBills = widget.widgetListBills;
    this.loadSharedPrefs();
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC75b98583d94173cdeb25eead1758371c',
        authToken: '6bd80f4a3d20342a8acae7384feaed2a',
        twilioNumber: '+15129692129');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var img = widget.billHeader["nameCreance"];

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FadeAnimation(
                1.2,
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
              ),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(
                1.4,
                Text(
                  "Aperçu du compte",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'avenir'),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              FadeAnimation(
                1.4,
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
              ),
              SizedBox(
                height: 40,
              ),
              FadeAnimation(
                1.6,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "list des factures" +
                          " : " +
                          widget.billHeader["nameCreance"],
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'avenir'),
                    ),
//                    Container(
//                      height: 30,
//                      width: 30,
//                      decoration: BoxDecoration(
//                          image: DecorationImage(
//                              image: AssetImage('asset/images/$img.png'))),
//                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              FadeAnimation(1.6
                , Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _isCodeValide ? Container():Container(child: Center(
                      child: Text("invalide code ",style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontFamily: 'avenir')),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 20,),
              this.listBills == null
                  ? Container()
                  : _isLoading ? Container() : FadeAnimation(
                  1.6,
                  SingleChildScrollView(
                    //scrollDirection: Axis.vertical,
                    child: this.listBills["bills"].length == 0
                        ? Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Text(
                          "Vous n'avez pas des factures a payez !",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: this.listBills["bills"].length,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 76,
                          margin: EdgeInsets.only(bottom: 13),
                          padding: EdgeInsets.only(
                              left: 24,
                              top: 12,
                              bottom: 12,
                              right: 22),
                          decoration: BoxDecoration(
                            color: Color(0xfff1f3f6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (!this
                                  .listBills["bills"][index]["isBatched"]) {
                                showAlertDialog(
                                    context, this.listBills["bills"][index],
                                    widget.billHeader["nameCreancier"]);
                                sendSms(this.listBills["bills"][index]["amount"]);
                              }

                              print(this.listBills["bills"][index]);
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                                              "asset/images/${widget
                                                  .billHeader["nameCreancier"]}.png"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          widget.billHeader[
                                          "nameCreance"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          this
                                              .listBills["bills"]
                                          [index]
                                          ["billingDate"]
                                              .substring(0, 10),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight:
                                              FontWeight.w400,
                                              color: Colors.grey),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      this
                                          .listBills["bills"]
                                      [index]["amount"]
                                          .toString() +
                                          " MAD",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue),
                                    ),
                                    this.listBills["bills"][index]["isBatched"]
                                        ? Text("En cours de ", style: TextStyle(
                                        color: Colors.redAccent
                                    ),)
                                        : Container(),

                                    this.listBills["bills"][index]["isBatched"]
                                        ? Text("traitement ", style: TextStyle(
                                        color: Colors.redAccent
                                    ),)
                                        : Container(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),


            ],

          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, var Bill, String nameCreancier) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("Valider"),
      onPressed: () {
        try {
          setState(() {
            _isLoading = true;
          });

          if(codeController.text==codeVerification.toString()){
            getPayer(Bill, nameCreancier);
            Navigator.of(context, rootNavigator: true).pop();
            _isCodeValide=true;
          }else{
            setState(() {
              _isCodeValide=false;
              getbills(widget.billHeader["genericID"],
                  widget.billHeader["nameCreancier"],
                  widget.billHeader["codeCreance"]);
            });

            Navigator.of(context, rootNavigator: true).pop();
          }

        } on Exception catch (e) {
          print(e);
        }


      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Anuler"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Validation"),
      content: Container(
        height: 150,
        child: Column(
          children: <Widget>[

            Text("Entrez le code recu par sms pour valider la transaction"),
            TextFormField(
                controller: codeController,
                decoration: InputDecoration(

                  labelText: "code verification",
                ))

          ],
        ),
      ),
      actions: [
        okButton,
        cancelButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getPayer(var Bill, String nameCreancier) async {
    String url = "https://ensapay-client-cmi-exchanger.herokuapp.com/payment/${Bill["id"]}/6015c008ce6a934eb137f067/$nameCreancier";
    print(url);
    try {
      var response = await http.get(
          url, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          getbills(widget.billHeader["genericID"],
              widget.billHeader["nameCreancier"],
              widget.billHeader["codeCreance"]);
        });
        client.account.solde = client.account.solde - Bill["amount"];
        sharedPref.save("client", client);
      } else {
        print("nod ");
      }
    } on Exception {
      print("exception");
    }
  }

  getbills(String genericId, String creancier, String codeCreance) async {
    String url = "https://ensapay-client-cmi-exchanger.herokuapp.com/bills/$creancier/$codeCreance/$genericId";
    print(url);
    try {
      var response = await http.get(
          url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        if (this.listBills != null) {
          setState(() {
            _isLoading = false;
            this.listBills = json.decode(response.body);
          });
        }
      } else {
        print("error in billsPage");
        setState(() {
          _isLoading = false;
        });
      }
    } on Exception {


    }
  }

  Client client = new Client();
  SharedPref sharedPref = new SharedPref();

  loadSharedPrefs() async {
    try {
      Client clientInShared = Client.fromJson(await sharedPref.read("client"));
      setState(() {
        this.client = clientInShared;
      });
    } catch (Excepetion) {
      print("withSizedBar");
      print(Excepetion.toString());
    }
  }
  void sendSms(double amount) async {
    final _random = new Random();
      print("hmmmmmmmmmmmmmm");
    /**
     * Generates a positive random integer uniformly distributed on the range
     * from [min], inclusive, to [max], exclusive.
     */
    codeVerification = 10000 + _random.nextInt(99999 - 10000);
    twilioFlutter.sendSMS(
        toNumber: "+212641927210",
        messageBody: "Afin de verifier votre payment sur internet de "+ amount.toString()+" MAD Veuillez saisir le code :"+codeVerification.toString());
  }

}