import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QRScreen extends StatelessWidget {
  final String userName;
  final String userId;
  final String userEmail;

  const QRScreen({
    super.key,
    required this.userName,
    required this.userId,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    // Generate a unique QR code data string using the user's ID
    final String qrData = 'https://example.com/user/$userId';

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2), // Light background color
      body: SafeArea(
        child: Column(
          children: [
            // Card container for QR code
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF9DC468), // Green background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back button and title row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                context,
                              ); // Navigate back to the home screen
                            },
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'My QR',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24),

                      // Profile picture
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // Name - dynamically display the userName
                      Text(
                        userName.isNotEmpty ? userName : 'User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 6),

                      // Email - dynamically display the userEmail
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),

                      SizedBox(height: 24),

                      // QR Code - use the dynamic qrData
                      Container(
                        width: 200,
                        height: 200,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          backgroundColor: Colors.white,
                          size: 180,
                        ),
                      ),

                      SizedBox(height: 12),

                      // Display user ID
                      Text(
                        'ID: ${userId.length > 8 ? userId.substring(0, 8) + '...' : userId}',

                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
