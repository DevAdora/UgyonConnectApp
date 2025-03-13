import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_bloc.dart';
import 'login_state.dart';
import 'register_screen.dart';
import 'main_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

void _navigateToSignup(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SignupScreen()),
  );
}

void _navigateToMain(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              alignment: Alignment.center, // Centers the image
              child: Image.asset(
                'assets/images/ugyon_logo.png',
                height: MediaQuery.of(context).size.height * 0.20,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width *
                  0.9, // 90% of screen width
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/images/google_icon.png', height: 24),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Inter',
                    letterSpacing: -0.424,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft, // Aligns text to the left
              child: Text(
                "Or use your email to login",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  letterSpacing: -0.424,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF505050),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Color(0XFF9DC468),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF9DC468), // Underline color

                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToMain(context),
                child: const Text('Log in'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF9DC468),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('New to Ugyon?'),
                TextButton(
                  onPressed: () => _navigateToSignup(context),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Color(0xFF9DC468), // Text color
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF9DC468), // Underline color
                      fontSize: 16,
                    ),
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
