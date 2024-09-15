import 'package:flutter/material.dart';
import 'package:molle/Views/Screens/Auth/select_username.dart';

class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/club.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Phone Verification',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 30),
                    // _buildTextField(
                    //   hintText: 'Phone Number',
                    //   icon: Icons.phone,
                    // ),
                    const SizedBox(height: 60),
                    _buildTextField(
                      hintText: 'OTP',
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.pink,
                            Colors.deepPurple
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  UsernameScreen(),
                              ));
                          // Handle verification action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, Colors.transparent],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                              minHeight: 23.0,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildTextField({required String hintText, required IconData icon}) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
