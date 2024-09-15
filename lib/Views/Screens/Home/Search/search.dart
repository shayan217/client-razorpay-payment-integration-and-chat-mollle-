import 'package:flutter/material.dart';
import 'package:molle/Controllers/api_servie_login.dart';
import 'package:molle/Views/Screens/Home/BottomNav/bottomnav.dart';
import '../../../../Models/userDto.dart';
import '../../../../Models/eventDto.dart';
import '../../../../Utils/constants.dart';
import '../Profile/user_profile.dart';
import '../SingleEvent/single_event.dart';
import '../userprofile/users.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  List<Event> _searchEventResults = [];
  List<User> _searchUserResults = [];
  bool _isLoading = false;
  String _searchQuery = '';
  int _selectedTabIndex = 0;
  String _errorMessage = '';

  List<Event> _availableEvents = []; // List to hold fetched events
  List<User> _availableUsers = []; // List to hold fetched users

  @override
  void initState() {
    super.initState();
    _fetchInitialData(); // Fetch initial data when the screen loads
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch available events and users
      final events =
          await _authService.fetchEvents(1); // Fetch first page of events
      final users = await _authService.searchUsers(''); // Fetch all users

      setState(() {
        _availableEvents = events;
        _availableUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load initial data. Please try again.';
      });
      print('Error fetching initial data: $e');
    }
  }

  Future<User> _fetchHostDetails(int userId) async {
    try {
      return await _authService.getUserProfile(userId);
    } catch (e) {
      print('Failed to load host details: $e');
      throw Exception('Failed to load host details.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          elevation: 1,
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              onSubmitted: (query) {
                setState(() {
                  _searchQuery = query;
                  _isLoading = true;
                  _errorMessage = '';
                });
                _performSearch(query);
              },
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.qr_code_scanner, color: Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
                _searchEventResults.clear();
                _searchUserResults.clear();
              });
            },
            tabs: [
              Tab(text: 'Events'),
              Tab(text: 'Users'),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: _buildEventList(),
                      ),
                      _buildUserList(),
                    ],
                  ),
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedTabIndex == 0) {
        // Search events
        final results = await _authService.searchEvents(query);
        setState(() {
          _searchEventResults =
              results.map((data) => Event.fromJson(data)).toList();
        });
      } else {
        // Search users
        final results = await _authService.searchUsers(query);
        setState(() {
          _searchUserResults = results;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while searching. Please try again.';
        print('Search error: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildEventList() {
    final listData =
        _searchQuery.isEmpty ? _availableEvents : _searchEventResults;

    if (listData.isEmpty) {
      return Center(child: Text('No events found.'));
    }

    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index) {
        final event = listData[index];
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
          event.createdByUserId,
          // Pass the user ID of the host
          context,
        );
      },
    );
  }

  Widget _buildUserList() {
    final listData =
        _searchQuery.isEmpty ? _availableUsers : _searchUserResults;

    if (listData.isEmpty) {
      return Center(child: Text('No users found.'));
    }

    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index) {
        final user = listData[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              user.image != null
                  ? 'https://molleadmin.com/public/assets/source/${user.image}'
                  : 'https://via.placeholder.com/150',
            ),
          ),
          title: Text(user.fullname),
          subtitle: Text('@${user.username ?? 'N/A'}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  user: user,
                ),
              ),
            );
          },
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
    int? createdByUserId, // Make this parameter nullable
    BuildContext context,
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
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
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
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(location,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      const Icon(Icons.people, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(members, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: createdByUserId != null
                            ? () async {
                                // Fetch the host details
                                User host =
                                    await _fetchHostDetails(createdByUserId);
                                // Navigate to User Profile screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfile(user: host),
                                  ),
                                );
                              }
                            : null, // Disable button if createdByUserId is null
                        child: Text(
                          'View Host',
                          style: TextStyle(
                              fontSize: 12, color: ColorConstants.mainColor2),
                        ),
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
