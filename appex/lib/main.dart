import 'package:appex/providers/theme_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'authentication/Auth.dart';
import 'pages/HomePage.dart';
import 'utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Add your ThemeProvider here
      ],
      child: MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey[900],
      ),
      home: AuthStreamBuilder(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }

}

class AuthStreamBuilder extends StatelessWidget {
  const AuthStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const HomePage();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
