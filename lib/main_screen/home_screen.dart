import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'transaction_screen.dart'; // ✅ Import TransactionPage
import 'package:qr_flutter/qr_flutter.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MapPage(), // ✅ Navigates properly
    ScannerPage(), // ✅ Navigates properly
    TransactionPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Updated bottomNavigationBar in your _HomeScreenState class
  // Updated bottomNavigationBar in your _HomeScreenState class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
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
            top: -15, // Reduced overlap to prevent overflow
            child: GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                width: 56, // Slightly smaller
                height: 56, // Slightly smaller
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF9DC468), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.grid_view, color: Color(0xFF9DC468), size: 28),
                    SizedBox(height: 2),
                    Text(
                      "Your QR",
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF505050),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

// ✅ Home Page
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ✅ Fixed 'appBar' property
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Color(0XFF9DC468),
              size: 26,
            ), // Profile Icon
            SizedBox(width: 8), // Space between icon and text
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22,

                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Default color
                ),
                children: [
                  TextSpan(
                    text: "Hello, ",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.32,
                    ),
                  ),
                  TextSpan(
                    text: "Japheth", // Green-colored name
                    style: TextStyle(
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
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsSection(),
            SizedBox(height: 20),
            _buildNearbyStation(),
            SizedBox(height: 20),
            _buildRewardsSection(),
          ],
        ),
      ),
    );
  }
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

Widget _buildNearbyStation() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Nearby Station",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          letterSpacing: -0.32,
        ),
      ),
      SizedBox(height: 20),
      Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: NearbyMap(),
      ),
    ],
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
      image: DecorationImage(
        image: AssetImage(imagePath), // ✅ Uses different image for each card
        fit: BoxFit.cover, // ✅ Ensures the image fills the container
      ),
    ),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(
          0.4,
        ), // ✅ Adds slight overlay for text visibility
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

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map")),
      body: Center(child: Text("Map Page", style: TextStyle(fontSize: 22))),
    );
  }
}

`class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
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

                      // Name
                      Text(
                        'Japheth G. Gonzales',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 24),

                      // QR Code
                      Container(
                        width: 200,
                        height: 200,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: QrImageView(
                          data: 'https://example.com/user/japheth_g_gonzales',
                          version: QrVersions.auto,
                          backgroundColor: Colors.white,
                          size: 180,
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

// ✅ Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Profile header with avatar and name
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.black,
                          ),
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
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Japheth G. Gonzales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Settings container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.edit,
                      title: 'Edit Profile Name',
                      context: context,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.lock,
                      title: 'Change Password',
                      context: context,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.email,
                      title: 'Change Email Address',
                      context: context,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      context: context,
                    ),
                    _buildDivider(),
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      isLogout: true,
                      context: context,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom navigation bar
          ],
        ),
      ),
    );
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
}

class NearbyMap extends StatefulWidget {
  const NearbyMap({super.key});

  @override
  _NearbyMapState createState() => _NearbyMapState();
}

class _NearbyMapState extends State<NearbyMap> {
  LatLng _userLocation = LatLng(37.7749, -122.4194); // Default: San Francisco

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(initialCenter: _userLocation, initialZoom: 14),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _userLocation,
              width: 50.0,
              height: 50.0,
              child: Icon(Icons.location_pin, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
