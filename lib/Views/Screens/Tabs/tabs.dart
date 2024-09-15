import 'package:flutter/material.dart';
import 'package:molle/Utils/constants.dart';
import 'package:molle/Views/Screens/Auth/Signup.dart';

import '../Auth/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildPageContent(
      {required String image, required String title, required String body}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              body,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                height: 1.2,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              _buildPageContent(
                image: 'assets/party1.jpeg',
                title: 'Discover amazing parties nearby',
                body:
                    'Find the best parties happening around you and stay updated with just a tap.',
              ),
              _buildPageContent(
                image: 'assets/party2.jpg',
                title: 'Secure and easy booking',
                body:
                    'Effortles'
                        'sly find and book tickets for a hassle-free and secure experience.',
              ),
              _buildPageContent(
                image: 'assets/party4.jpg',
                title: 'Personalized recommendations',
                body:
                    'Get suggestions tailored to your taste and never miss your favorite events.',
              ),
              _buildPageContent(
                image: 'assets/party5.jpg',
                title: 'Exclusive deals and perks',
                body:
                    'Access unique deals and early-bird tickets. Enjoy app-only benefits.',
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) =>  LoginScreen(),
                      ),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Row(children: _buildPageIndicator()),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {
                        if (_currentPage < 3) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ));
                          // Proceed to the next screen or home screen
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: ColorConstants.mainColor,
                        size: 25.0,
                      ),
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
