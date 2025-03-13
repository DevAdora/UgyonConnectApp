import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    MapPage(), // ✅ Navigates properly
    ScannerPage(), // ✅ Navigates properly
    RewardsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0XFF9DC468),
        unselectedItemColor: Color(0xFF505050),
        showSelectedLabels: false, // ❌ Removes text labels
        showUnselectedLabels: false, // ❌ Removes text labels
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Icon(Icons.home),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Icon(Icons.map),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Icon(Icons.scanner),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Icon(Icons.shopping_bag),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Icon(Icons.person),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}

// ✅ Home Page
class HomePage extends StatelessWidget {
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
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter', letterSpacing: -0.32),
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
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter', letterSpacing: -0.32),
      ),
      SizedBox(height: 20),
      Container(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map")),
      body: Center(child: Text("Map Page", style: TextStyle(fontSize: 22))),
    );
  }
}

class ScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scanner")),
      body: Center(child: Text("Scanner Page", style: TextStyle(fontSize: 22))),
    );
  }
}

// ✅ Rewards Page
class RewardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rewards")),
      body: Center(child: Text("Rewards Page", style: TextStyle(fontSize: 22))),
    );
  }
}

// ✅ Profile Page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(child: Text("Profile Page", style: TextStyle(fontSize: 22))),
    );
  }
}

class NearbyMap extends StatefulWidget {
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
