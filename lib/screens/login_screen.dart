import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ugyon/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const LoginScreen());
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      // working
      print(userCredential);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/ugyon_logo.png',
                height: MediaQuery.of(context).size.height * 0.17,
              ),
            ),
            const SizedBox(height: 50),
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
            const SizedBox(height: 30),

            Container(
              padding: EdgeInsets.only(bottom: 10), // Bottom padding
              alignment: Alignment.centerLeft,
              child: const Text(
                "Or use your email to login",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF505050),
                ),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
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
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Color(0XFF505050),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF505050),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🔥 Login Button with Loading Indicator
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => loginUserWithEmailAndPassword(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF9DC468),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Log in'),
              ),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('New to Ugyon?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, SignUpScreen.route());
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF9DC468),
                      decorationColor: Color(0xFF9DC468),
                      decoration: TextDecoration.underline,
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
