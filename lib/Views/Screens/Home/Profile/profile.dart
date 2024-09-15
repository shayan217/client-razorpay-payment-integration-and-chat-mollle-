import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import image package for resizing
import '../../../../Controllers/api_servie_login.dart';
import '../../../../Models/eventDto.dart';
import '../../../../Models/userDto.dart';
import '../../../../Utils/constants.dart';
import '../BottomNav/bottomnav.dart';
import '../Settings/Profile_settings.dart';
import '../Settings/settings.dart';
import '../SingleEvent/single_event.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = true;
  int _followerCount = 0;
  int _followedCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authService.getProfile();
      setState(() {
        _user = user;
        _isLoading = false;
      });
      await _loadFollowers();
      await _loadFollowedUsers();
    } catch (e) {
      print('Failed to load user profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onProfileUpdated(User updatedUser) {
    // Update the profile with the new data
    setState(() {
      _user = updatedUser;
    });
  }

  Future<void> _loadFollowers() async {
    try {
      final followers = await _authService.getFollowers();
      setState(() {
        _followerCount = followers.length;
      });
    } catch (e) {
      print('Failed to load followers: $e');
    }
  }

  Future<void> _loadFollowedUsers() async {
    try {
      final followedUsers = await _authService.getFollowedUsers();
      setState(() {
        _followedCount = followedUsers.length;
      });
    } catch (e) {
      print('Failed to load followed users: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Resize and compress the image before uploading
      _resizeAndUploadImage(imageFile);
    }
  }

  Future<void> _resizeAndUploadImage(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load the image
      final bytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      // Resize the image to make sure it's smaller than 2048 KB
      final resizedImage = img.copyResize(decodedImage!, width: 500);

      // Compress the image to ensure it is under 2048 KB
      final compressedImage = img.encodeJpg(resizedImage, quality: 85);

      // Save the compressed image to a temporary file
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/resized_profile_image.jpg')
        ..writeAsBytesSync(compressedImage);

      // Upload the resized and compressed image
      final updatedUser = await _authService.updateProfileImage(tempFile);
      setState(() {
        _user = updatedUser; // Update user state with the latest profile data
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully!')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              color: Colors.white,
            )),
        backgroundColor: ColorConstants.mainColor,
        elevation: 0,
        title: Text(
          _user?.username ?? 'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                _buildProfileInfo(),
                const SizedBox(height: 16),
                _buildStats(),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  indicatorColor: ColorConstants.mainColor,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'My Events'),
                    Tab(text: 'Attended'),
                    Tab(text: 'Liked'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEventList(_user?.eventsByUser ?? []),
                      _buildEventList(_user?.eventsAttended ?? []),
                      _buildEventList(_user?.eventsLiked ?? []),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: _user?.image != null
                ? NetworkImage(_buildFullImageUrl(_user!.image!))
                : AssetImage('assets/default_profile.png') as ImageProvider,
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _user?.fullname ?? 'User Name',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _buildFullImageUrl(String imagePath) {
    if (!imagePath.startsWith('http')) {
      return 'https://molleadmin.com$imagePath'; // Concatenate with base URL
    }
    return imagePath;
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Followers', _followerCount.toString()),
        _buildStatItem('Followed', _followedCount.toString()),
        _buildStatItem('Hosted', '0'), // Adjust this if you fetch hosted count
      ],
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEventList(List<Event> events) {
    if (events.isEmpty) {
      return Center(child: Text('No events found'));
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(
          event.id,
          event.name,
          event.startDate,
          event.image,
          event.location,
          '${event.startTime} - ${event.endTime}',
          event.amount,
          event.seatLimit.toString(),
          event.description,
          context,
        );
      },
    );
  }

  Widget _buildEventCard(
    int id,
    String title,
    String date,
    String imagePath,
    String location,
    String time,
    double price,
    String members,
    String description,
    BuildContext context,
    // int minimumAge,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleEventScreen(
              title: title,
              members: members,
              date: date,
              imagePath: imagePath,
              location: location,
              time: time,
              price: price,
              description: description,
              eventId: id,
              // minimumAge: minimumAge,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                _buildFullImageUrl(imagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          date,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          time,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.people, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        members,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
