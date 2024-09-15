// import 'package:flutter/material.dart';
// import 'package:molle/Controllers/api_servie_login.dart';
// import 'package:molle/Models/userDto.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   final int userId;
//
//   UserProfileScreen({required this.userId});
//
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final AuthService _authService = AuthService();
//   User? user;
//   bool isFollowing = false;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       // Load user profile data
//       user = await _authService.getUserProfile(widget.userId);
//
//       // Check if the user is followed
//       await _checkIfFollowing();
//
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading user data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _checkIfFollowing() async {
//     try {
//       // Fetch the list of followed users
//       List<User> followedUsers = await _authService.getFollowedUsers();
//
//       // Check if the user is in the followed users list
//       setState(() {
//         isFollowing = followedUsers.any((followedUser) => followedUser.id == widget.userId);
//       });
//     } catch (e) {
//       print('Error checking if following: $e');
//     }
//   }
//
//   Future<void> _toggleFollow() async {
//     try {
//       if (isFollowing) {
//         await _authService.unfollowUser(widget.userId);
//         setState(() {
//           isFollowing = false;
//         });
//       } else {
//         final response = await _authService.followUser(widget.userId);
//         if (response.message == 'User followed successfully.') {
//           setState(() {
//             isFollowing = true;
//           });
//         } else if (response.message == 'You are already following this user.') {
//           setState(() {
//             isFollowing = true;
//           });
//         } else {
//           throw Exception('Failed to follow user: ${response.message}');
//         }
//       }
//     } catch (e) {
//       print('Error toggling follow: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: Text('User Profile')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: Text(user?.fullname ?? 'User Profile')),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: NetworkImage(
//                 user?.image != null
//                     ? 'https://molleadmin.com/public/assets/source/${user!.image}'
//                     : 'https://via.placeholder.com/150',
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(user?.fullname ?? '', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             Text('@${user?.username ?? 'N/A'}', style: TextStyle(fontSize: 16, color: Colors.grey)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _toggleFollow,
//               child: Text(isFollowing ? 'Unfollow' : 'Follow'),
//             ),
//             SizedBox(height: 20),
//             ListTile(
//               leading: Icon(Icons.email),
//               title: Text(user?.email ?? 'N/A'),
//             ),
//             ListTile(
//               leading: Icon(Icons.phone),
//               title: Text(user?.phoneNumber ?? 'N/A'),
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text(user?.gender ?? 'N/A'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:molle/Controllers/api_servie_login.dart';
import 'package:molle/Models/userDto.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  UserProfileScreen({required this.userId});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  User? user;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load user profile data
      user = await _authService.getUserProfile(widget.userId);

      // Check if the user is followed
      await _checkIfFollowing();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkIfFollowing() async {
    try {
      // Fetch the list of followed users
      List<User> followedUsers = await _authService.getFollowedUsers();

      // Check if the user is in the followed users list
      setState(() {
        isFollowing = followedUsers
            .any((followedUser) => followedUser.id == widget.userId);
      });
    } catch (e) {
      print('Error checking if following: $e');
    }
  }

  Future<void> _toggleFollow() async {
    try {
      if (isFollowing) {
        // Unfollow the user
        await _authService.unfollowUser(widget.userId);
        setState(() {
          isFollowing = false;
        });
      } else {
        // Follow the user
        final response = await _authService.followUser(widget.userId);
        if (response.message == 'User followed successfully.' ||
            response.message == 'You are already following this user.') {
          setState(() {
            isFollowing = true;
          });
        } else {
          throw Exception('Failed to follow user: ${response.message}');
        }
      }
    } catch (e) {
      print('Error toggling follow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('User Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(user?.fullname ?? 'User Profile')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user?.image != null && user!.image!.isNotEmpty
                    ? 'https://molleadmin.com/public/assets/source/${user!.image}'
                    : 'https://via.placeholder.com/150',
              ),
            ),
            SizedBox(height: 10),
            Text(user?.fullname ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('@${user?.username ?? 'N/A'}',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleFollow,
              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(user?.email ?? 'N/A'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(user?.phoneNumber ?? 'N/A'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(user?.gender ?? 'N/A'),
            ),
          ],
        ),
      ),
    );
  }
}
