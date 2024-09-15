import 'package:flutter/material.dart';
import 'package:molle/Utils/constants.dart';
import 'package:molle/Views/Screens/Home/Settings/settings.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool followNotifications = true;
  bool likeNotifications = true;
  bool participationNotifications = true;
  bool invitationNotifications = true;
  bool eventChatNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
            // Handle back action
          },
        ),
        title: Text('Notification',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              // Handle save action
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
        elevation: 0, // Remove shadow
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SwitchListTile(
            title: Text('Follow Notifications'),
            value: followNotifications,
            onChanged: (bool value) {
              setState(() {
                followNotifications = value;
              });
            },
            activeColor: Colors.blue,
          ),
          Divider(color: Colors.grey[300]),
          SwitchListTile(
            title: Text('Like Notifications'),
            value: likeNotifications,
            onChanged: (bool value) {
              setState(() {
                likeNotifications = value;
              });
            },
            activeColor: Colors.blue,
          ),
          Divider(color: Colors.grey[300]),
          SwitchListTile(
            title: Text('Participation Notifications'),
            value: participationNotifications,
            onChanged: (bool value) {
              setState(() {
                participationNotifications = value;
              });
            },
            activeColor: Colors.blue,
          ),
          Divider(color: Colors.grey[300]),
          SwitchListTile(
            title: Text('Invitation Notifications'),
            value: invitationNotifications,
            onChanged: (bool value) {
              setState(() {
                invitationNotifications = value;
              });
            },
            activeColor: Colors.blue,
          ),
          Divider(color: Colors.grey[300]),
          SwitchListTile(
            title: Text('Event Chat Notifications'),
            value: eventChatNotifications,
            onChanged: (bool value) {
              setState(() {
                eventChatNotifications = value;
              });
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
