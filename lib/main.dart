import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'splash_screen.dart';
import 'login_screen_1.dart'; 
import 'firebase_options.dart'; // ✅ Add this missing import
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // ✅ Use the options
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ), 
      ],
      child: const MyApp(),
    ),
  );
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
