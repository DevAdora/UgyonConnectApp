import 'package:flutter/material.dart';
import 'main_screen/home_screen.dart';
import 'register_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // To show loading indicator

  // ✅ Firestore Authentication Function
  Future<void> _signInWithRealtimeDB() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      // ✅ Reference to the Realtime Database users collection
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users');

      // 🔥 Query the database to find matching email
      final snapshot = await dbRef.orderByChild('email').equalTo(email).get();

      if (snapshot.exists && snapshot.value != null) {
        // ✅ Iterate through the results
        final Map<dynamic, dynamic> usersMap =
            snapshot.value as Map<dynamic, dynamic>;
        bool isAuthenticated = false;
        String? userId;
        Map<String, dynamic>? userData;

        usersMap.forEach((key, value) {
          if (value['password'] == password) {
            isAuthenticated = true;
            userId = key; // ✅ Store the User ID
            userData = Map<String, dynamic>.from(value);
          }
        });

        if (isAuthenticated && userId != null) {
          print("USER DATA STRUCTURE: ${userData.toString()}");
          userData!.forEach((key, value) {
            print("FIELD: $key = $value");
          });

          // Rest of your existing code...
          // ...

          // ✅ Store the user ID and data locally using SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId!);
          await prefs.setString('userEmail', email);
          await prefs.setString('userName', userData!['name'] ?? '');
          await prefs.setString('userPhone', userData!['phone'] ?? '');
          await prefs.setString('userQRCode', userData!['qrCode'] ?? '');

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login successful!')));

          // ✅ Navigate to HomeScreen (or UserScreen)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // ❌ Incorrect password
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Invalid password')));
        }
      } else {
        // ❌ Email not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found with this email')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
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
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
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
                onPressed: _isLoading ? null : _signInWithRealtimeDB,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF9DC468),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Log in'),
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
