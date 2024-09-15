// import 'package:flutter/material.dart';
// import '../../../../Controllers/api_servie_login.dart';
// import '../../../../Models/userDto.dart';
// import '../../../../Utils/constants.dart';
// import '../Chat/chat_screen.dart';
//
// class UserProfile extends StatefulWidget {
//   final User user;
//
//   const UserProfile({Key? key, required this.user}) : super(key: key);
//
//   @override
//   _UserProfileState createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   final AuthService _authService = AuthService();
//   bool isFollowing = false;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfFollowing();
//   }
//
//   Future<void> _checkIfFollowing() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       List<User> followedUsers = await _authService.getFollowedUsers();
//       setState(() {
//         isFollowing = followedUsers.any((user) => user.id == widget.user.id);
//       });
//     } catch (e) {
//       print('Failed to check if following: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _followUser() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       await _authService.followUser(widget.user.id);
//       setState(() {
//         isFollowing = true;
//       });
//       _showSnackBar('You are now following ${widget.user.fullname}');
//     } catch (e) {
//       print('Failed to follow user: $e');
//       _showSnackBar('Failed to follow user.');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _unfollowUser() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       await _authService.unfollowUser(widget.user.id);
//       setState(() {
//         isFollowing = false;
//       });
//       _showSnackBar('You have unfollowed ${widget.user.fullname}');
//     } catch (e) {
//       print('Failed to unfollow user: $e');
//       _showSnackBar('Failed to unfollow user.');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _startChat() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Chat(
//             receiverId: widget.user.id,
//           ),
//         ),
//       );
//     } catch (e) {
//       print('Failed to initiate chat: $e');
//       _showSnackBar('Failed to start a chat.');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.user.fullname),
//         backgroundColor: ColorConstants.mainColor,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(widget.user.image ?? ''),
//                     onBackgroundImageError: (_, __) => const Icon(Icons.person),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     widget.user.fullname,
//                     style: const TextStyle(
//                         fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Email: ${widget.user.email}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Phone: ${widget.user.phoneNumber}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Username: ${widget.user.username ?? 'N/A'}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Gender: ${widget.user.gender}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: isFollowing ? _unfollowUser : _followUser,
//                         child: Text(isFollowing ? 'Unfollow' : 'Follow'),
//                       ),
//                       ElevatedButton(
//                         onPressed: _startChat,
//                         child: const Text('Message'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../Controllers/api_servie_login.dart';
import '../../../../Models/userDto.dart';
import '../../../../Utils/constants.dart';
import '../Chat/chat_screen.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _authService = AuthService();
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<User> followedUsers = await _authService.getFollowedUsers();
      setState(() {
        isFollowing = followedUsers.any((user) => user.id == widget.user.id);
      });
    } catch (e) {
      print('Failed to check if following: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _followUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _authService.followUser(widget.user.id);
      setState(() {
        isFollowing = true;
      });
      _showSnackBar('You are now following ${widget.user.fullname}');
    } catch (e) {
      print('Failed to follow user: $e');
      _showSnackBar('Failed to follow user.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _unfollowUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _authService.unfollowUser(widget.user.id);
      setState(() {
        isFollowing = false;
      });
      _showSnackBar('You have unfollowed ${widget.user.fullname}');
    } catch (e) {
      print('Failed to unfollow user: $e');
      _showSnackBar('Failed to unfollow user.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _startChat() async {
    setState(() {
      isLoading = true;
    });
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(
            receiverId: widget.user.id,
          ),
        ),
      );
    } catch (e) {
      print('Failed to initiate chat: $e');
      _showSnackBar('Failed to start a chat.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.fullname),
        backgroundColor: ColorConstants.mainColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.user.image ?? ''),
                    onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.user.fullname,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Hide sensitive details
                  const Text(
                    'This user prefers to keep their details private.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: isFollowing ? _unfollowUser : _followUser,
                        child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                      ),
                      ElevatedButton(
                        onPressed: _startChat,
                        child: const Text('Message'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
