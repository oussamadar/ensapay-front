import 'package:ensapay/Login.dart';
import 'package:flutter/material.dart';
import 'Homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/Client.dart';
import 'Model/SharedPref.dart';
class HomeWithSidebar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWithSidebar(),
    );
  }
}
class homeWithSidebar extends StatefulWidget {
  @override
  _homeWithSidebarState createState() => _homeWithSidebarState();
}

class _homeWithSidebarState extends State<homeWithSidebar> with TickerProviderStateMixin{
  bool sideBarActive = false;
  Color maincolor =  Color.fromRGBO(143, 148, 251, 1);
  Color secondColor =Color(0xffffac30);
  AnimationController rotationController;
  SharedPref sharedPref = new SharedPref();

  Client client;
  @override
  void initState() {
    // TODO: implement initState

    rotationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    super.initState();
    loadSharedPrefs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f3f6),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width*0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
                        color: Colors.white
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xfff1f3f6),
                                image: DecorationImage(
                                    image: AssetImage('asset/images/avatar4.png'),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(this.client.lastName+" "+this.client.firstName, style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700
                              ),),
                              Text(this.client.address ,style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    navigatorTitle("Acceuille", true),
                    navigatorTitle("Profile", false),

                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      size: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        sharedPref.remove("client");
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Login()), (Route<dynamic> route) => false);
                      },
                      child: Text("Logout", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),),
                    )
                  ],
                ),
              ),

            ],
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: (sideBarActive) ? MediaQuery.of(context).size.width*0.6 : 0,
            top: (sideBarActive)? MediaQuery.of(context).size.height*0.2 : 0,
            child: RotationTransition(
              turns: (sideBarActive) ? Tween(begin: -0.05, end: 0.0).animate(rotationController) : Tween(begin: 0.0, end: -0.05).animate(rotationController),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: (sideBarActive) ? MediaQuery.of(context).size.height*0.7 : MediaQuery.of(context).size.height,
                width: (sideBarActive) ? MediaQuery.of(context).size.width*0.8 : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: HomePage(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: (sideBarActive) ? IconButton(
              padding: EdgeInsets.all(30),
              onPressed: closeSideBar,
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
            ): InkWell(
              onTap: openSideBar,
              child: Container(
                margin: EdgeInsets.all(17),
                height: 30,
                width: 30,
//                decoration: BoxDecoration(
//                    image: DecorationImage(
//                        image: AssetImage('asset/images/menu.png')
//                    )
//                ),
                child: Icon(Icons.menu),
              ),

            ),
          )
        ],
      ),
    );
  }
  Row navigatorTitle(String name, bool isSelected)
  {
    return Row(
      children: [
        (isSelected) ? Container(
          width: 5,
          height: 60,
          color: Color(0xffffac30),
        ):
        Container(width: 5,
          height: 60,),
        SizedBox(width: 10,height: 60,),
        Text(name, style: TextStyle(
            fontSize: 16,
            fontWeight: (isSelected) ? FontWeight.w700: FontWeight.w400
        ),)
      ],
    );
  }
  void closeSideBar()
  {
    sideBarActive = false;
    setState(() {

    });
  }
  void openSideBar()
  {
    sideBarActive = true;
    setState(() {

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