import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:walk_for_future/services/auth_service.dart';
import 'package:walk_for_future/pages/sign_in_page.dart';
import 'package:walk_for_future/widgets/user.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    PermissionStatus permissionStatus = PermissionStatus.denied;
      void requestPermission() async{
    await Permission.storage.request();
    permissionStatus = await Permission.activityRecognition.request();
                  while (!permissionStatus.isGranted) {
                    await Permission.activityRecognition.request();
                  }

  }

  @override
  void initState(){
    super.initState();
    requestPermission();

  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          Provider<UserFromFirebase>(
            create: (_) => UserFromFirebase(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SignInPage(),
        ));
  }
}


