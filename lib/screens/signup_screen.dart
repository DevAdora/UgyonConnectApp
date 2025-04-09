import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SignUpScreen());
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordHidden = true;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      // working
      // need to redirect to login after sign up & save the user to firestore,
      // and add
      print(userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9DC468),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create your account to start earning rewards!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF505050),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextField("Full Name", Icons.person, nameController),
                    const SizedBox(height: 12),
                    _buildTextField("Work email", Icons.work, emailController),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Phone number",
                      Icons.phone,
                      phoneController,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Strong password",
                      Icons.lock,
                      passwordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          createUserWithEmailAndPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BC34A),
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
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isPasswordHidden : false,
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
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed:
                        () => setState(
                          () => isPasswordHidden = !isPasswordHidden,
                        ),
                  )
                  : Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }
}
