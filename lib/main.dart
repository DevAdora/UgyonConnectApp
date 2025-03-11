import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'splash_screen.dart'; 
import 'login_screen_1.dart'; // Ensure this import exists

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()), // Provide LoginBloc globally
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
      home: const SplashScreen(nextScreen: LoginScreen1()), // Navigate to Login after Splash
    );
  }
}
