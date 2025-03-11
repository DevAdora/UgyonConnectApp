import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignupScreen(),
  ));
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80), // Spacing from top

            // 🔹 Title
            const Text(
              "Get Started",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7CB342), // Light Green
              ),
            ),

            const SizedBox(height: 5),

            // 🔹 Subtitle
            const Text(
              "Create your account to start earning rewards!",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),

            const SizedBox(height: 60),

            // 🔹 Input Fields
            _buildTextField("Full Name", Icons.person),
            const SizedBox(height: 12),
            _buildTextField("Work email", Icons.work),
            const SizedBox(height: 12),
            _buildTextField("Phone number", Icons.phone),
            const SizedBox(height: 12),
            _buildTextField("Strong password", Icons.lock, isPassword: true),

            const SizedBox(height: 15),

            // 🔹 Terms & Conditions
            const Center(
              child: Text.rich(
                TextSpan(
                  text: "By signing up, you agree to our ",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const Spacer(),

            // 🔹 Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BC34A), // Light green
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 🔹 Custom Input Field Widget
  Widget _buildTextField(String hintText, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Colors.black54),
      ),
    );
  }
}
