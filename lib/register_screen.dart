import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'email_verification.dart'; // For OTP screen

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordHidden = true;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔥 Global key for rendering QR code to image
  final GlobalKey _qrKey = GlobalKey();

  Future<void> _registerUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // ✅ Generate 6-digit OTP
      final otp = (Random().nextInt(900000) + 100000).toString();

      // ✅ Generate a unique QR code using the user's email
      final qrData =
          '${_emailController.text}-${DateTime.now().millisecondsSinceEpoch}';

      // ✅ Store user data in Firebase Realtime Database
      final newUserRef = _dbRef.child('users').push();
      await newUserRef.set({
        'createdAt': DateTime.now().toIso8601String(),
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password':
            _passwordController.text, // Store hashed password in production
        'otp': otp,
        'qrCode': qrData, // ✅ Store the QR code data
      });

      // ✅ Save user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', newUserRef.key ?? '');
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userEmail', _emailController.text);
      await prefs.setString('userPhone', _phoneController.text);
      await prefs.setString('userPassword', _passwordController.text);
      await prefs.setString('userQRCode', qrData);

      Fluttertoast.showToast(msg: "User registered successfully!");

      // ✅ Navigate to OTP screen with email & OTP
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(email: _emailController.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // 🔥 Function to render QR code to an image and convert to bytes
  Future<Uint8List?> _captureQrCode() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('❌ Error capturing QR code: $e');
      return null;
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
                    _buildTextField("Full Name", Icons.person, _nameController),
                    const SizedBox(height: 12),
                    _buildTextField("Work email", Icons.work, _emailController),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Phone number",
                      Icons.phone,
                      _phoneController,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      "Strong password",
                      Icons.lock,
                      _passwordController,
                      isPassword: true,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RepaintBoundary(
                      key: _qrKey,
                      child: QrImageView(
                        data: _emailController.text, // Use email as the QR data
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerUser,
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
                    onPressed:
                        () => setState(
                          () => _isPasswordHidden = !_isPasswordHidden,
                        ),
                  )
                  : Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }
}
