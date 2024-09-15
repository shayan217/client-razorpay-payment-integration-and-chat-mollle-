import 'package:flutter/material.dart';
import 'package:molle/Utils/constants.dart';
import 'package:molle/Views/Screens/Home/BottomNav/bottomnav.dart';
import 'package:molle/Views/Screens/Home/Notifications/notifications.dart';
import 'package:molle/Controllers/api_servie_login.dart'; // Import AuthService
import 'package:molle/Views/Screens/Auth/login.dart'; // Import LoginScreen
import 'package:molle/Views/Screens/Home/Privacy/privacy_policy.dart';

import '../../../../Models/userDto.dart';
import '../Profile/profile.dart';
import '../Qr_Code/QR-screen.dart';
import 'Profile_settings.dart';

class SettingsScreen extends StatelessWidget {
  final AuthService _authService = AuthService(); // Instantiate AuthService

  void _logout(BuildContext context) async {
    try {
      await _authService.logout(); // Call logout method
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      ); // Navigate to LoginScreen and remove all previous routes
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to logout: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNav(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: ColorConstants.mainColor,
        title: const Center(
            child: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SettingsCard(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsScreen(
                      onProfileUpdated: (User updatedUser) {
                        // Handle the profile update logic here
                        // For example, you might want to refresh the ProfileScreen
                      },
                    ),
                  ),
                );
              },
            ),
            SettingsCard(
              icon: Icons.qr_code,
              title: 'Privacy Policies',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Privacy(),
                    ));
              },
            ),
            SettingsCard(
              icon: Icons.qr_code,
              title: 'QR Code',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QRCodeScreen(),
                    ));
              },
            ),
            SettingsCard(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationSettingsScreen(),
                    ));
              },
            ),
            SettingsCard(
              icon: Icons.block,
              title: 'Blocked Users',
              onTap: () {
                // Navigate to Blocked Users
              },
            ),
            SettingsCard(
              icon: Icons.event_busy,
              title: 'Blocked Events',
              onTap: () {
                // Navigate to Blocked Events
              },
            ),
            SettingsCard(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () {
                // Navigate to Privacy Policy
              },
            ),
            SettingsCard(
              icon: Icons.article,
              title: 'Terms of Service',
              onTap: () {
                // Navigate to Terms of Service
              },
            ),
            SettingsCard(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                _logout(context); // Call _logout when tapped
              },
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const SettingsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ColorConstants.mainColor,
          child: Icon(icon, color: textColor ?? Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, color: textColor ?? Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
