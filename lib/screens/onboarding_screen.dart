import 'package:flutter/material.dart';
import 'package:ugyon/screens/login_page.dart';
import 'package:ugyon/screens/signup_page.dart';
import 'package:ugyon/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/slide_1.png',
      'title': 'Recycle and\nearn rewards',
      'subtitle': 'Drop bottles, collect points!',
    },
    {
      'image': 'assets/images/slide_2.png',
      'title': 'Redeem\nrewards',
      'subtitle': 'Use points for exclusive perks!',
    },
    {
      'image': 'assets/images/slide_3.png',
      'title': 'Make an\nimpact',
      'subtitle': 'Recycle today, change tomorrow!',
    },
  ];

  void _nextPage() {
    if (_currentPage == pages.length - 1) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              final page = pages[index];
              return Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      page['image']!,
                      width: MediaQuery.of(context).size.width,
                      height:
                          MediaQuery.of(context).size.width *
                          (500 / MediaQuery.of(context).size.width),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        page['title']!,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        page['subtitle']!,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        children: List.generate(
                          pages.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            width: 20,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  _currentPage == index
                                      ? AppColors.primary
                                      : AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 8,
            right: 24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(minimumSize: Size.zero),
                    onPressed: () {
                      if (_currentPage == pages.length - 1) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const SignUpPage()),
                        );
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }
                    },
                    child: Text(
                      _currentPage == pages.length - 1 ? 'Register' : 'Skip',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: _nextPage,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: AppColors.primary,
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
}
