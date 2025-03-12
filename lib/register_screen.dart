import 'package:flutter/material.dart';
import 'email_verification.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SignupScreen()),
  );
}

void _navigateToEmailVer(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const OtpScreen()),
  );
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordHidden = true; // Password visibility state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Evenly distribute sections
            children: [
              // 🔹 Top Section: Title & Subtitle
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Get Started",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9DC468),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create your account to start earning rewards!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF505050),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Middle Section: Input Fields
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField("Full Name", Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField("Work email", Icons.work),
                    const SizedBox(height: 12),
                    _buildTextField("Phone number", Icons.phone),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Strong password",
                      Icons.lock,
                      isPassword: true,
                    ),
                  ],
                ),
              ),

              // 🔹 Bottom Section: Button
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text.rich(
                      TextSpan(
                        text: "By signing up, you agree to our ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF505050),
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(
                              color: Color(0xFF9DC468),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: Color(0xFF9DC468),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // "Next" Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToEmailVer(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF8BC34A,
                          ), // Light green
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hintText,
    IconData icon, {
    bool isPassword = false,
  }) {
    return SizedBox(
      width: double.infinity, // Ensures fields are centered
      child: TextField(
        obscureText: isPassword ? _isPasswordHidden : false,
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      _isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  )
                  : Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }
}
