import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart'; // For OTP input
import 'number_verification.dart'; // Import the NumberVerification screen

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: OtpScreen()),
  );
}

void _navigateToNumVer(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const NumScreen()),
  );
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _resendTime = 30; // Countdown for resend OTP
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTime > 0) {
        setState(() {
          _resendTime--;
        });
        _startResendTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Title & Subtitle
              Column(
                children: [
                  const Text(
                    "Verify Your Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9DC468),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter the 6-digit code sent to your email: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF505050)),
                  ),
                  const Text(
                    "yourname@email.com",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9DC468),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // 🔹 OTP Input
              Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              // 🔹 Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToNumVer(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Verify", style: TextStyle(fontSize: 18)),
                ),
              ),

              // 🔹 Resend & Warning Text
              Column(
                children: [
                  const Text(
                    "Do not share your OTP with anyone. Ugyon will never ask for your code.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF505050)),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: "Didn’t receive the code? ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF505050),
                      ),
                      children: [
                        TextSpan(
                          text:
                              _resendTime > 0
                                  ? "Resend Again (in $_resendTime s)"
                                  : "Resend Now",
                          style: const TextStyle(
                            color: Color(0xFF9DC468),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
