import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'splash_screen.dart';
import 'login_screen_1.dart';
import 'firebase_options.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Initialize Firebase with error handling
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // ✅ Initialize SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    // ✅ Handle Firebase or SharedPreferences initialization errors
    debugPrint('Initialization error: $e');
    debugPrint('StackTrace: $stackTrace');

    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
             'Error initializing app. Please restart.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(
        nextScreen: LoginScreen1(),
      ),
    );
  }
}
