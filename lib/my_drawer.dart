import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/const_colors.dart';
import 'package:tcc_hugo/services/auth_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthService>(
        builder: (context, auth, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(150),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: auth.usuario!.photoURL != null
                          ? FadeInImage.assetNetwork(
                              fit: BoxFit.fitHeight,
                              width: 80,
                              placeholder: "assets/images/loading_postagem.gif",
                              image: auth.usuario!.photoURL!,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return ClipRect(
                                        child: Align(
                                          widthFactor: 0.62,
                                          heightFactor: 0.78,
                                          alignment: Alignment.center,
                                          child: Lottie.asset(
                                            "assets/lotties/profile_avatar.json",
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                              },
                            )
                          : Container(
                            color: kSecundaryColor,
                            height: 80,
                            width: 80,
                            child: Center(
                              child: Text(
                                  auth.usuario!.displayName![0].toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold, color: kWhite),
                                ),
                            ),
                          ),
                    ),
                    // CircleAvatar(
                    //   radius: 40,

                    //   child: Text(auth.usuario!.displayName![0].toUpperCase(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
                    // ),
                    SizedBox(height: 10),
                    Text(
                      auth.usuario!.displayName!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      auth.usuario!.email!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Perfil do Tutor'),
                onTap: () {
                  Navigator.pushNamed(context, '/perfilTutor');
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.settings),
              //   title: Text('Configurações'),
              //   onTap: () {
              //     // Navegar para a página de configurações
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Avaliar Usabilidade'),
                onTap: () {
                  Navigator.pushNamed(context, '/avaliacao');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sair'),
                onTap: () async {
                  await context.read<AuthService>().logout();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
