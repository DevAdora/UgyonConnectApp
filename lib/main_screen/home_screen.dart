import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String _userName = "";
String _userEmail = "";
String _userId = "";
// Get first name for personalized greeting
String get _firstName {
  return _userName.isEmpty ? "User" : _userName.split(' ').first;
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetailsFromPrefs();
  }

  Future<void> _fetchUserDetailsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _userEmail = prefs.getString('userEmail') ?? '';
      _userName = prefs.getString('userName') ?? 'User';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create pages list inside build to pass the current user data
    final List<Widget> _pages = [
      HomePage(userName: _firstName),
      ShopPage(),
      ScannerPage(userName: _userName, userId: _userId, userEmail: _userEmail),
      TransactionPage(),
      ProfilePage(userName: _userName, userId: _userId, userEmail: _userEmail),
    ];

    return Scaffold(
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF9DC468)),
              )
              : _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Regular bottom navigation bar with increased height
          Container(
            height: 80, // Increased height to accommodate overflow
            padding: EdgeInsets.only(bottom: 8), // Bottom padding
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildNavItem(0, Icons.home, "Home")),
                Expanded(child: _buildNavItem(1, Icons.shopping_bag, "Shop")),
                // Empty space for center item
                Expanded(child: SizedBox(width: 10)),
                Expanded(
                  child: _buildNavItem(
                    3,
                    Icons.article_outlined,
                    "Transactions",
                  ),
                ),
                Expanded(
                  child: _buildNavItem(4, Icons.person_outline, "Profile"),
                ),
              ],
            ),
          ),

          // Prominent QR button
          Positioned(
            top: -25, // Adjust as needed
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Column(
                children: [
                  // The circle container with the icon only
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF9DC468), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.grid_view,
                      color: Color(0xFF9DC468),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text displayed outside of the circle
                  Text(
                    "Your QR",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF505050),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? Color(0xFF9DC468) : Color(0xFF505050),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11, // Slightly smaller font
              color: isSelected ? Color(0xFF9DC468) : Color(0xFF505050),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.account_circle,
              color: Color(0XFF9DC468),
              size: 26,
            ),
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(
                    text: "Hello, ",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.32,
                    ),
                  ),
                  TextSpan(
                    text: _firstName, // Using the passed userName
                    style: const TextStyle(
                      color: Color(0xFF9DC468),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          bottom: 16,
        ), // Top padding added here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection(),
            const SizedBox(height: 30),
            _buildCard(),
            const SizedBox(height: 30),
            _buildRewardsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF9DC468),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem("My Points", "50.2"),
          _buildStatItem("Saved CO₂", "50.2g"),
          _buildStatItem("Recycled bottle", "50.2"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            color: Color(0xFFFFEA9C),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFDFDFD),
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cards",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
            letterSpacing: -0.32,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCardStation(
                "Apply for Your Ugyon Card Now!",
                "Enjoy seamless recycling rewards and exclusive perks",
                [
                  Color(0xFFFDFDFD), // Darker Green
                  Color(0xFFCBE9A3), // Darker Green
                ],
              ),
              _buildCardStation(
                "Your Recycling Impact",
                "CO₂ Saved: Track your environmental impact.",
                [
                  Color(0xFFFDFDFD), // Darker Green
                  Color(0xFFCBE9A3), // Darker Green
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardStation(
    String title,
    String points,
    List<Color> gradientColors,
  ) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.5),
            Text(
              points,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                color: Color(0xFF505050),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rewards",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
            letterSpacing: -0.32,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRewardCard(
                "Donate To Ugyon",
                "1pt",
                "assets/images/slide1_ugyon.png",
              ),
              _buildRewardCard(
                "Jollibee Burger Meals",
                "100pts",
                "assets/images/slide2_jollibee.png",
              ),
              _buildRewardCard(
                "Gift Voucher",
                "60pts",
                "assets/images/slide3.png",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard(String title, String points, String imagePath) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFFFDFDFD),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2.5),
            Text(
              points,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                color: Color(0xFFFDFDFD),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shop")),
      body: Center(child: Text("Shop Page", style: TextStyle(fontSize: 22))),
    );
  }
}

// Updated ScannerPage to use dynamic user data
class ScannerPage extends StatelessWidget {
  final String userName;
  final String userId;
  final String userEmail;

  const ScannerPage({
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
                              // Handle back button press if needed
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

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Icon(Icons.notifications, color: Colors.grey),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          TransactionCard(date: '01', month: 'April'),
          TransactionCard(date: '29', month: 'March'),
          TransactionCard(date: '01', month: 'April'),
          TransactionCard(date: '29', month: 'March'),
          TransactionCard(date: '24', month: 'March'),
          TransactionCard(date: '20', month: 'March'),
          TransactionCard(date: '16', month: 'March'),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String date;
  final String month;

  const TransactionCard({super.key, required this.date, required this.month});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: Color(0xFF9DC468),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF51840A),
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF505050),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Bottles: 2 Small, 3 Medium, 1 Large',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Points Earned: 15 pts',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    'CO₂ Saved: 0.3 kg',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Status: Completed',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9DC468)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated ProfilePage to use dynamic user data
class ProfilePage extends StatelessWidget {
  final String userName;
  final String userId;
  final String userEmail;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userId,
    required this.userEmail,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9DC468),
      body: SafeArea(
        child: Column(
          children: [
            // Profile header
            _buildProfileHeader(context),

            // Settings container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.edit,
                      title: 'Edit Profile Name',
                      context: context,
                      onTap: () => _showEditModal(context, "Edit Profile Name"),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.lock,
                      title: 'Change Password',
                      context: context,
                      onTap: () => _showEditModal(context, "Change Password"),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.email,
                      title: 'Change Email Address',
                      context: context,
                      onTap:
                          () => _showEditModal(context, "Change Email Address"),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      context: context,
                      onTap: () => _showPlaceholder(context),
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      isLogout: true,
                      context: context,
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// ✅ Profile Header Function
  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.person, size: 50, color: Colors.black),
                ),
              ),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Icon(Icons.check, color: Colors.white, size: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            userName.isNotEmpty ? userName : 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            userEmail,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// ✅ Settings Item Function
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required BuildContext context,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  /// ✅ Divider Function
  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1,
      height: 0,
      indent: 16,
      endIndent: 16,
    );
  }

  /// ✅ Logout Function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  /// ✅ Modal Function for Edit Profile, Password, and Email
  void _showEditModal(BuildContext context, String title) {
    TextEditingController _controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: title,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle submission logic
                    print('$title updated: ${_controller.text}');
                    Navigator.pop(context); // Close modal
                  },
                  child: Text('Save'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  /// ✅ Placeholder for Settings
  void _showPlaceholder(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Settings placeholder action")));
  }
}

Widget _buildSettingsItem({
  required IconData icon,
  required String title,
  bool isLogout = false,
  required BuildContext context,
}) {
  return InkWell(
    onTap: () {
      // Handle tap
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  isLogout
                      ? Colors.red.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isLogout ? Colors.red : Colors.black,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isLogout ? Colors.red : Colors.black,
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
        ],
      ),
    ),
  );
}

Widget _buildDivider() {
  return const Divider(
    height: 1,
    thickness: 1,
    indent: 16,
    endIndent: 16,
    color: Color(0xFFEEEEEE),
  );
}
