import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'qr_screen.dart';
import 'dart:developer' as developer;

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
      HomePage(
        userName: _userName,
        userId: _userId,
      ), // Corrected _userName here
      ShopPage(),
      QRScreen(userName: _userName, userId: _userId, userEmail: _userEmail),
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
                Expanded(child: _buildNavItem(0, "home", "Home")),
                Expanded(child: _buildNavItem(1, "shop", "Shop")),
                Expanded(
                  child: SizedBox(width: 10),
                ), // Empty space for center item
                Expanded(
                  child: _buildNavItem(3, "transaction", "Transactions"),
                ),
                Expanded(child: _buildNavItem(4, "user", "Profile")),
              ],
            ),
          ),
          // Prominent QR button
          Positioned(
            top: -25, // Adjust as needed
            child: GestureDetector(
              onTap:
                  () => _navigateToQRScreen(
                    context,
                  ), // Trigger navigation to QRScreen
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

  // Add this method to navigate to the QR screen
  void _navigateToQRScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QRScreen(
              userName: _userName,
              userId: _userId,
              userEmail: _userEmail,
            ),
      ),
    );
  }

  Widget _buildNavItem(int index, String assetName, String label) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/icons/$assetName.svg",
            width: 24, // Adjust size as needed
            height: 24,
            colorFilter: ColorFilter.mode(
              _selectedIndex == index ? Color(0xFF9DC468) : Color(0xFF505050),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color:
                  _selectedIndex == index
                      ? Color(0xFF9DC468)
                      : Color(0xFF505050),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String userName;
  final String userId;

  const HomePage({super.key, required this.userName, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  double _totalPoints = 0.0;
  double _totalCO2 = 0.0;
  int _totalBottles = 0;

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  // Fetch transaction data from Firebase
  Future<void> _fetchTransactionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Fetching transactions for user: ${widget.userId}");

      final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
      DatabaseReference transactionsRef = _dbRef
          .child('transactions')
          .child(widget.userId);
      final snapshot = await transactionsRef.get();

      if (snapshot.exists) {
        double points = 0.0;
        int bottles = 0;

        Map<dynamic, dynamic> transactionsMap =
            snapshot.value as Map<dynamic, dynamic>;

        transactionsMap.forEach((txnId, transaction) {
          if (transaction is Map<dynamic, dynamic>) {
            int small = transaction["small"] ?? 0;
            int medium = transaction["medium"] ?? 0;
            int large = transaction["large"] ?? 0;
            double txnPoints =
                double.tryParse(transaction["points"]?.toString() ?? "0") ??
                0.0;

            bottles += small + medium + large;
            points += txnPoints;
          }
        });

        setState(() {
          _totalPoints = points;
          _totalBottles = bottles;
          _totalCO2 = bottles * 0.02; // Example CO₂ calculation
          _isLoading = false;
        });

        print("Transaction data fetched successfully");
        print("Total Points: $_totalPoints");
        print("Total CO2 Saved: $_totalCO2");
        print("Total Bottles: $_totalBottles");
      } else {
        print("No transactions found for this user");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching transaction data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                    text: _getFirstName(),
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
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Color(0xFF9DC468)),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsSection(),
                    const SizedBox(height: 30),
                    _buildCard(),
                    const SizedBox(height: 30),
                    _buildRewardsSection(),
                    const SizedBox(height: 30),
                    HelpSection(),
                  ],
                ),
              ),
    );
  }

  // Helper to get first name
  String _getFirstName() {
    return widget.userName.isEmpty ? "User" : widget.userName.split(' ').first;
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
          _buildStatItem("My Points", "${_totalPoints.toStringAsFixed(1)}"),
          _buildStatItem("Saved CO₂", "${_totalCO2.toStringAsFixed(1)}g"),
          _buildStatItem("Recycled Bottles", "$_totalBottles"),
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

  // The rest of your original code for _buildCard(), _buildCardStation(), etc.
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

// Keep the HelpSection as is
class HelpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(Icons.help_outline, color: Color(0xFF9DC468), size: 24),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "We're Here to Help",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Find answers to common questions",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        _buildHelpItem(Icons.chat, "What is Ugyon Connect?"),
        _buildHelpItem(Icons.recycling, "How do I deposit plastic bottles?"),
        _buildHelpItem(Icons.card_giftcard, "How do I redeem my points?"),
      ],
    );
  }

  Widget _buildHelpItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF9DC468)),
      title: Text(title, style: const TextStyle(fontSize: 14)),
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
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Color(0xFFCBE9A3),
                borderRadius: BorderRadius.circular(24),
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
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bottles: ', // Bold and colored part
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF505050), // Your preferred color
                          ),
                        ),
                        TextSpan(
                          text: '2 Small, 3 Medium, 1 Large', // Regular text
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF505050),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Points Earned: ', // Bold and colored part
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF505050),
                          ),
                        ),
                        TextSpan(
                          text: '15 pts',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF505050),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'CO₂ Saved: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF505050),
                          ),
                        ),
                        TextSpan(
                          text: '0.3 kg',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF505050),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF505050),
                          ),
                        ),
                        TextSpan(
                          text: 'Completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF51840A),
                          ),
                        ),
                      ],
                    ),
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

class ProfilePage extends StatefulWidget {
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
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _userName;
  late String _userEmail;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _userEmail = widget.userEmail;

    // Debug print to verify initial values
    print(
      "ProfilePage initialized with: $_userName, $_userEmail, ${widget.userId}",
    );
  }

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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 15.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSettingsItem(
                      icon: Icons.edit,
                      title: 'Edit Profile Name',
                      context: context,
                      onTap: () => _showEditNameModal(context),
                    ),
                    _buildSettingsItem(
                      icon: Icons.lock,
                      title: 'Change Password',
                      context: context,
                      onTap: () => _showChangePasswordModal(context),
                    ),
                    _buildSettingsItem(
                      icon: Icons.email,
                      title: 'Change Email Address',
                      context: context,
                      onTap: () => _showChangeEmailModal(context),
                    ),
                    _buildSettingsItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      context: context,
                      onTap: () => _showPlaceholder(context),
                    ),
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

  /// Profile Header Function
  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
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
                  child: Icon(Icons.person, size: 50, color: Color(0xFF505050)),
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
            _userName.isNotEmpty ? _userName : 'User',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _userEmail,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Settings Item Function
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required BuildContext context,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Color(0xFF505050)),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Color(0xFF505050),
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _logout(BuildContext context) async {
    try {
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Error logging out: $e");
      _showErrorSnackbar(context, "Failed to log out. Please try again.");
    }
  }

  /// Edit Name Modal
  void _showEditNameModal(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: _userName,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Edit Profile Name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'New Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Debug print
                  print(
                    "Save button pressed for name update: ${controller.text}",
                  );

                  // First close dialog, then update - this prevents UI freeze
                  Navigator.pop(context);
                  _updateUserName(context, controller.text);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  /// Change Password Modal
  void _showChangePasswordModal(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Debug print
                  print("Save button pressed for password update");

                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                    // First close dialog, then update
                    Navigator.pop(context);
                    _updatePassword(
                      context,
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
                  } else {
                    _showErrorSnackbar(context, "New passwords don't match");
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  /// Change Email Modal
  void _showChangeEmailModal(BuildContext context) {
    final TextEditingController emailController = TextEditingController(
      text: _userEmail,
    );
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Change Email Address'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'New Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password (for verification)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Debug print
                  print(
                    "Save button pressed for email update: ${emailController.text}",
                  );

                  // First close dialog, then update
                  Navigator.pop(context);
                  _updateEmail(
                    context,
                    emailController.text,
                    passwordController.text,
                  );
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  /// Update User Name in Firebase
  Future<void> _updateUserName(BuildContext context, String newName) async {
    if (newName.isEmpty) {
      _showErrorSnackbar(context, "Name cannot be empty");
      return;
    }

    try {
      // Show loading indicator
      _showLoadingDialog(context);
      print("Updating name to: $newName");

      // Update user name in Realtime Database
      await _database
          .child('users')
          .child(widget.userId)
          .update({'name': newName})
          .then((_) {
            print("Database name updated successfully");
          })
          .catchError((error) {
            print("Error updating database name: $error");
            throw error;
          });

      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', newName);

      print("All updates completed, updating UI");
      // Update state to reflect changes
      setState(() {
        _userName = newName;
      });

      // Hide loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Show success message
      _showSuccessSnackbar(context, "Profile name updated successfully");
    } catch (e) {
      print("Error in _updateUserName: $e");
      // Hide loading dialog if still showing
      Navigator.of(context, rootNavigator: true).pop();

      // Show error message
      _showErrorSnackbar(context, "Failed to update name: ${e.toString()}");
    }
  }

  /// Update User Password in Firebase
  Future<void> _updatePassword(
    BuildContext context,
    String currentPassword,
    String newPassword,
  ) async {
    if (newPassword.isEmpty) {
      _showErrorSnackbar(context, "Password cannot be empty");
      return;
    }

    if (newPassword.length < 6) {
      _showErrorSnackbar(context, "Password must be at least 6 characters");
      return;
    }

    try {
      // Show loading indicator
      _showLoadingDialog(context);
      print("Attempting to update password");

      // You'll need to implement your own password verification logic
      // against your database here

      // If you're storing password hashes in your database:
      // 1. First verify the current password is correct
      // 2. Then update the password hash for the new password

      // Example (pseudo-code):
      // await _database.child('users').child(widget.userId).once().then((snapshot) {
      //   if (verifyPassword(currentPassword, snapshot.value['passwordHash'])) {
      //     _database.child('users').child(widget.userId).update({
      //       'passwordHash': hashPassword(newPassword)
      //     });
      //   } else {
      //     throw Exception('Current password is incorrect');
      //   }
      // });

      // For this example, we'll just show a placeholder message
      // Replace this with your actual implementation
      await Future.delayed(Duration(seconds: 2));

      // Hide loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Show success message
      _showSuccessSnackbar(context, "Password updated successfully");
    } catch (e) {
      print("Error in _updatePassword: $e");
      // Hide loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      _showErrorSnackbar(context, "Failed to update password: ${e.toString()}");
    }
  }

  /// Update User Email in Firebase
  Future<void> _updateEmail(
    BuildContext context,
    String newEmail,
    String password,
  ) async {
    if (newEmail.isEmpty) {
      _showErrorSnackbar(context, "Email cannot be empty");
      return;
    }

    // Simple email validation
    final bool emailValid = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(newEmail);
    if (!emailValid) {
      _showErrorSnackbar(context, "Please enter a valid email address");
      return;
    }

    try {
      // Show loading indicator
      _showLoadingDialog(context);
      print("Attempting to update email to: $newEmail");

      // If you need to verify the password, you'll need to implement
      // a custom authentication check against your database

      // Update email in Realtime Database
      await _database
          .child('users')
          .child(widget.userId)
          .update({'email': newEmail})
          .then((_) {
            print("Database email updated successfully");
          })
          .catchError((error) {
            print("Database email update failed: $error");
            throw error;
          });

      // Update in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', newEmail);

      print("All updates completed, updating UI");
      // Update state to reflect changes
      setState(() {
        _userEmail = newEmail;
      });

      // Hide loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Show success message
      _showSuccessSnackbar(context, "Email updated successfully");
    } catch (e) {
      print("Error in _updateEmail: $e");
      // Hide loading dialog
      Navigator.of(context, rootNavigator: true).pop();
      _showErrorSnackbar(context, "Failed to update email: ${e.toString()}");
    }
  }

  /// Show Loading Dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Please wait..."),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show Success Snackbar
  void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show Error Snackbar
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Placeholder for Settings
  void _showPlaceholder(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Settings placeholder action")));
  }
}
