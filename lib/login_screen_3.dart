import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'login_state.dart';
import 'main_screen/home_screen.dart';


class LoginScreen3 extends StatefulWidget {
  const LoginScreen3({super.key});

  @override
  _LoginScreen3State createState() => _LoginScreen3State();
}

Color hexColor(String hex) {
  hex = hex.replaceAll("#", "");
  return Color(int.parse("0xFF$hex"));
}

class _LoginScreen3State extends State<LoginScreen3> {
  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
          onTap: () => _navigateToHome(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                  
             Transform.translate(
                offset: const Offset(30, 0), // Moves right by 20 pixels
                child: Image.asset(
                  'assets/images/ugyon_thirdscreen_image.png',
                  width: 500,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
                const SizedBox(height: 20),

                // 🔹 Title
                const Text(
                  "Make an Impact",
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
                  "Recylce today, change tomorrow!",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 30),

                // 🔹 Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(isActive: false),
                    _buildDot(isActive: false),
                    _buildDot(isActive: true),
                  ],
                ),

                const Spacer(),

                // 🔹 Bottom Row (Skip + Arrow Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _navigateToHome(context),
                      child: const Text(
                        "register",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () => _navigateToHome(context),
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
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
