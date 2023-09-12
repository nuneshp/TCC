import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_hugo/services/avaliacao_service.dart';
import 'package:tcc_hugo/repositorys/consulta_repository.dart';
import 'package:tcc_hugo/repositorys/foto_repository.dart';
import 'package:tcc_hugo/repositorys/postagem_repository.dart';
import 'package:tcc_hugo/services/firebase_messaging_service.dart';
import 'package:tcc_hugo/services/notification_service.dart';
import 'package:tcc_hugo/services/devices_service.dart';
import 'myApp.dart';
import 'repositorys/antiparasitario_repository.dart';
import 'repositorys/peso_repository.dart';
import 'repositorys/pet_repository.dart';
import 'repositorys/vermifugo_repository.dart';
import 'services/auth_service.dart';
import 'repositorys/banho_repository.dart';
import 'repositorys/tosa_repository.dart';
import 'repositorys/vacina_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  NotificationService().initializeNotifications();
  initializeDateFormatting().then((_) => runApp(MultiProvider(providers: [
        
        Provider<NotificationService>(
            create: (context) => NotificationService()),
        Provider<FirebaseMessagingService>(
            create: (context) =>
                FirebaseMessagingService(context.read<NotificationService>())),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, PetsRepository>(
          create: (context) =>
              PetsRepository(auth: context.read<AuthService>()),
          update: (context, auth, pets) => PetsRepository(auth: auth),
        ),
        ChangeNotifierProvider(
            create: (context) =>
                PostagensRepository(auth: context.read<AuthService>())),
        ChangeNotifierProxyProvider2<AuthService, PetsRepository,
            PesosRepository>(
          create: (context) => PesosRepository(
              auth: context.read<AuthService>(),
              pets: context.read<PetsRepository>()),
          update: (context, auth, pets, pesos) =>
              PesosRepository(auth: auth, pets: pets),
        ),
        ChangeNotifierProxyProvider2<AuthService, PetsRepository,
            VermifugosRepository>(
          create: (context) => VermifugosRepository(
              auth: context.read<AuthService>(),
              pets: context.read<PetsRepository>()),
          update: (context, auth, pets, vermifugos) =>
              VermifugosRepository(auth: auth, pets: pets),
        ),
        ChangeNotifierProxyProvider2<AuthService, PetsRepository,
            BanhosRepository>(
          create: (context) => BanhosRepository(
              auth: context.read<AuthService>(),
              pets: context.read<PetsRepository>()),
          update: (context, auth, pets, banhos) =>
              BanhosRepository(auth: auth, pets: pets),
        ),
        ChangeNotifierProxyProvider2<AuthService, PetsRepository,
            TosasRepository>(
          create: (context) => TosasRepository(
              auth: context.read<AuthService>(),
              pets: context.read<PetsRepository>()),
          update: (context, auth, pets, tosas) =>
              TosasRepository(auth: auth, pets: pets),
        ),
        ChangeNotifierProxyProvider2<AuthService, PetsRepository,
            VacinasRepository>(
          create: (context) => VacinasRepository(
              auth: context.read<AuthService>(),
              pets: context.read<PetsRepository>()),
          update: (context, auth, pets, vacinas) =>
              VacinasRepository(auth: auth, pets: pets),
        ),
        ChangeNotifierProxyProvider2<AuthService, PetsRepository,
            ConsultasRepository>(
          create: (context) => ConsultasRepository(
              auth: context.read<AuthService>(),
              pets: context.read<PetsRepository>()),
          update: (context, auth, pets, consultas) =>
              ConsultasRepository(auth: auth, pets: pets),
        ),
         ChangeNotifierProxyProvider2<AuthService, PetsRepository,FotosRepository>(
            create: (context) => FotosRepository(
                auth: context.read<AuthService>(),
                pets: context.read<PetsRepository>()),
                update: (context, auth, pets, fotos) => FotosRepository(auth: auth, pets: pets),),
         ChangeNotifierProxyProvider2<AuthService, PetsRepository,AntiparasitariosRepository>(
            create: (context) => AntiparasitariosRepository(
                auth: context.read<AuthService>(),
                pets: context.read<PetsRepository>()),
                update: (context, auth, pets, antiparasitarios) => AntiparasitariosRepository(auth: auth, pets: pets),),
        ChangeNotifierProvider(
            create: (context) => DevicesService(
                  auth: context.read<AuthService>(),
                )),
        ChangeNotifierProvider(
            create: (context) => AvaliacaoService(
                  auth: context.read<AuthService>(),
                )),
      ], child: const MyApp())));
}
