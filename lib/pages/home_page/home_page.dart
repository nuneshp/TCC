import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/my_drawer.dart';
import 'package:tcc_hugo/pages/home_page/components/calendario.dart';
import 'package:tcc_hugo/pages/home_page/components/gastosPets.dart';
import 'package:tcc_hugo/pages/home_page/components/listViewPostagens.dart';
import 'package:tcc_hugo/services/auth_service.dart';
import 'package:tcc_hugo/pages/home_page/components/listViewPets.dart';
import 'package:tcc_hugo/services/devices_service.dart';
import 'package:tcc_hugo/services/firebase_messaging_service.dart';
import 'package:tcc_hugo/services/notification_service.dart';
import 'package:tcc_hugo/widgets/util.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showNotifica =false;

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
    checkNotifications();
  }

  initializeFirebaseMessaging() async {
    await Provider.of<FirebaseMessagingService>(context, listen: false)
        .initialize();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

  // logout() async {
  //   try {
  //     await context.read<AuthService>().logout();
  //     await context.read<DevicesService>().removeToken();

  //   } on AuthException catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.message)));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Center(
            child: Text("AmigoPet",
                textAlign: TextAlign.center,
                style: TextStyle(color: kPrimaryColor))),
        iconTheme: const IconThemeData(color: kPrimaryColor),
        elevation: 1,
        backgroundColor: kWhite,
        actions: [
          InkWell(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.calendar_month),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Calendario(),
                  ),
                );
              }),
          // InkWell(
          //   child: const Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: Icon(Icons.notifications_none_rounded),
          //   ),
          //   onTap: () {
          //     setState(() {
          //       showNotifica=!showNotifica;
          //     });
          //   },
          // ),
          Consumer2<AuthService, DevicesService>(
              builder: (context, auth, devices, child) {
            return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.exit_to_app),
                ),
                onTap: () async {
                  try {
                    await devices.removeToken();
                    await auth.logout();
                  } on AuthException catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.message)));
                  }
                });
          })
        ],
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          print("oi");
          setState(() {});
        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
          
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthService>(
                    builder: (context, auth, child) {
                      return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            "Seja Bem Vind@, ${auth.usuario!.displayName}",
                            style: TextStyle(color: kPrimaryColor),
                          ));
                    },
                  ),
                  const ListViewPets(),
                  Espaco(),
                  Divider(),
                   ResumoDeGastos(),
                  
                  Espaco(),
                  Divider(),
                  const ListViewPostagens(),
                  Espaco(),
                  Divider(),
                 
                  
                ],
              ),
            ),
            if(showNotifica)
              Row(
                children: [
                  InkWell(
                    onTap: ()=> setState(() {
                      showNotifica=!showNotifica;
                    })
                    ,
                    child: Container(
                       width: 0.4*MediaQuery.of(context).size.width,
                    color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  Container(
                  width: 0.6*MediaQuery.of(context).size.width,
                  color: kWhite,
                  child: Column(
                    children: [
                      
                    ],
                  ),
            ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
