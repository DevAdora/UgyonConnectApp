import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'login_state.dart';
import 'login_screen_2.dart';
import 'login_screen.dart';

class LoginScreen1 extends StatefulWidget {
  const LoginScreen1({super.key});

  @override
  _LoginScreen1State createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1> {
  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen2()),
    );
  }

  void _skipToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: const Duration(seconds: 3),
                ),
              );
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Transform.translate(
                  offset: const Offset(30, 0), // Moves right by 20 pixels
                  child: Image.asset(
                    'assets/images/ugyon_screen_image.png',
                    width: 500,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Title
                const Text(
                  "Recycle and earn rewards",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF151515),
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 10),

                // 🔹 Subtitle
                const Text(
                  "Drop bottles, collect points!",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 30),

                // 🔹 Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(isActive: true),
                    _buildDot(isActive: false),
                    _buildDot(isActive: false),
                  ],
                ),

                const Spacer(),

                // 🔹 Bottom Row (Skip + Arrow Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _skipToHome(context),
                      child: const Text(
                        "skip",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () => _navigateToHome(context),
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
