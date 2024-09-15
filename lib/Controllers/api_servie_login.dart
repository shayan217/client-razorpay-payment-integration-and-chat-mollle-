import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import '../Models/eventDto.dart';
import '../Models/userDto.dart';
import 'auth_inspector.dart';

class AuthService {
  static const String baseUrl = 'https://molleadmin.com/api';
  final storage = FlutterSecureStorage();
  late final http.Client _client;
  AuthService() {
    _client = AuthInterceptor(http.Client(), storage);
  }
  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<String> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final result = jsonResponse['result'];
      if (result == null || result['access_token'] == null) {
        throw Exception(
            'Login successful but token is missing in the response');
      }
      String token = result['access_token'];
      await storage.write(key: 'auth_token', value: token);
      return token;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<User> register({
    required String fullname,
    required String email,
    required String password,
    required String phoneNumber,
    required String gender,
    String? imagePath,
  }) async {
    final uri = Uri.parse('$baseUrl/register');
    final request = http.MultipartRequest('POST', uri);
    request.fields['fullname'] = fullname;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['phone_number'] = phoneNumber;
    request.fields['gender'] = "Male";
    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }
    request.headers['Accept'] = 'application/json';
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      if (response.statusCode == 200 ||
          jsonResponse['message'] == 'User registered successfully') {
        final result = jsonResponse['result'];
        if (result != null) {
          User user = User.fromJson(result);
          if (user.accessToken != null) {
            await storage.write(key: 'auth_token', value: user.accessToken!);
          }
          return user;
        } else {
          throw Exception(
              'Registration successful, but user data is missing in the response');
        }
      } else {
        throw Exception(
            'Failed to register: ${jsonResponse['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception occurred during registration: $e');
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> logout() async {
    final token = await getToken();
    if (token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } catch (e) {
        print('Error during logout API call: $e');
      }
    }
    await storage.delete(key: 'auth_token');
  }

  Future<User> getProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final result = jsonResponse['result'];
      if (result['image'] != null && !result['image'].startsWith('http')) {
        result['image'] =
            'https://molleadmin.com/public/assets/source/${result['image']}';
      }
      return User.fromJson(result);
    } else {
      throw Exception('Failed to load profile: ${response.body}');
    }
  }

  Future<User> updateProfileImage(File imageFile) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final uri = Uri.parse('$baseUrl/set-profile');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    try {
      final cleanResponseBody = responseBody.replaceAll(r'\/', '/');
      final jsonResponse = json.decode(cleanResponseBody);
      print('Response status code: ${response.statusCode}');
      print('Response body: $cleanResponseBody');
      if (response.statusCode == 200) {
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse['message'] == 'Profile image updated successfully.') {
          final updatedUserJson = jsonResponse['result'];
          if (updatedUserJson['image'] != null &&
              !updatedUserJson['image'].startsWith('http')) {
            updatedUserJson['image'] =
                'https://molleadmin.com/public/assets/source/${updatedUserJson['image']}';
          }
          return User.fromJson(updatedUserJson);
        } else {
          throw Exception(
              'Unexpected response format: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to update profile image: ${jsonResponse['message']}');
      }
    } catch (e) {
      print('Error during parsing: $e');
      throw Exception('Failed to parse response: ${responseBody}');
    }
  }

  Future<bool> checkUsername(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/check-username'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result'] == true;
    } else {
      throw Exception('Failed to check username: ${response.body}');
    }
  }

  Future<void> setUsername(String username) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/set-username'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username}),
    );
    if (response.statusCode != 200) {
      final errorResponse = json.decode(response.body);
      throw Exception('Failed to set username: ${errorResponse['message']}');
    }
  }

  Future<User> getUserProfile(int userId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/profile-other-user'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return User.fromJson(jsonResponse['result']);
    } else {
      throw Exception('Failed to load user profile: ${response.body}');
    }
  }

  Future<List<User>> getFollowers() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.get(
      Uri.parse('$baseUrl/followers'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> followersJson = jsonResponse['result'];
      return followersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followers: ${response.body}');
    }
  }

  Future<ResponseMessage> followUser(int userId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/follow'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'followed_id': userId, "follow": true}),
    );
    final jsonResponse = json.decode(response.body);
    return ResponseMessage.fromJson(jsonResponse);
  }

  Future<ResponseMessage> unfollowUser(int userId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/follow'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'followed_id': userId, "follow": false}),
    );
    final jsonResponse = json.decode(response.body);
    return ResponseMessage.fromJson(jsonResponse);
  }

  Future<List<User>> getFollowedUsers() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.get(
      Uri.parse('$baseUrl/followed'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> followedUsersJson = jsonResponse['result'] ?? [];

      if (followedUsersJson is List) {
        return followedUsersJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } else {
      throw Exception('Failed to load followed users: ${response.body}');
    }
  }

  Future<List<dynamic>> searchEvents(String query) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/search-events?query=$query'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result']['data'] ?? [];
    } else {
      throw Exception('Failed to search events: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> uploadDocuments(
      File documentFront, File documentBack) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final uri = Uri.parse('$baseUrl/documents');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.files.add(await http.MultipartFile.fromPath(
      'document_front',
      documentFront.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'document_back',
      documentBack.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseBody);
    if (response.statusCode == 200 ||
        jsonResponse['message'] == 'Document created successfully.') {
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to upload documents: ${jsonResponse['message']}');
    }
  }

  Future<List<User>> searchUsers(String query) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.get(
      Uri.parse('$baseUrl/search-users?query=$query'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> usersJson = jsonResponse['result']['data'];
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search users: ${response.body}');
    }
  }

  Future<List<Event>> searchEventsByType(String query) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.get(
      Uri.parse('$baseUrl/search-events-by-type?query=$query'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> eventsJson = jsonResponse['result']['data'] ?? [];
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search events by type: ${response.body}');
    }
  }

  Future<void> reportEvent(int eventId) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await _client.post(
      Uri.parse('$baseUrl/report-event'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'reported_event_id': eventId}),
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse['message'] == 'Event reported successfully.') {
        return;
      } else if (jsonResponse['message'] ==
          'Event has already been reported by this user.') {
        throw Exception('Event has already been reported.');
      }
    } else {
      throw Exception('Failed to report event: ${jsonResponse['message']}');
    }
  }

  Future<void> likeEvent(int eventId, bool like) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');
    final response = await _client.post(
      Uri.parse('$baseUrl/event-like'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'event_id': eventId, 'like': like}),
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (like && jsonResponse['message'] == 'Event liked successfully.') {
        return;
      } else if (!like &&
          jsonResponse['message'] == 'Event unliked successfully.') {
        return;
      } else if (jsonResponse['message'].contains('already')) {
        throw Exception('Event already liked or unliked.');
      }
    } else {
      throw Exception(
          'Failed to like/unlike event: ${jsonResponse['message']}');
    }
  }

  Future<List<dynamic>> getLikedEvents() async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');
    final response = await _client.get(
      Uri.parse('$baseUrl/event-like'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 &&
        jsonResponse['message'] == 'Liked events retrieved successfully.') {
      return jsonResponse['result'] ?? [];
    } else {
      throw Exception(
          'Failed to fetch liked events: ${jsonResponse['message']}');
    }
  }

  Future<List<dynamic>> getReportedEvents() async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await _client.get(
      Uri.parse('$baseUrl/report-event'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 &&
        jsonResponse['message'] == 'Reported events retrieved successfully.') {
      return jsonResponse['result'] ?? [];
    } else {
      throw Exception(
          'Failed to fetch reported events: ${jsonResponse['message']}');
    }
  }

  Future<List<Event>> fetchEventsByCity(String city) async {
    final token = await getToken();
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/events?location=$city'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> eventsJson = jsonResponse['result']['data'] ?? [];
        if (eventsJson.isEmpty) {
          return [];
        }
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch events for city: ${response.body}');
      }
    } catch (e) {
      print('Error fetching events by city: $e');
      throw Exception('Failed to fetch events by city: $e');
    }
  }

  Future<List<Event>> fetchEvents(int page) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/events?page=$page'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> eventsJson = jsonResponse['result']['data'] ?? [];

      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch events: ${response.body}');
    }
  }

  Future<void> joinEvent(int eventId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/attend-event'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'event_id': eventId}),
    );
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (jsonResponse['message'] == 'Event joined successfully.') {
        return;
      } else {
        print('Unexpected success response: ${jsonResponse['message']}');
        return;
      }
    } else {
      throw Exception('Failed to join event: ${jsonResponse['message']}');
    }
  }

  Future<void> createEvent({
    required String name,
    required String eventTypeId,
    required String location,
    required String startTime,
    required String endTime,
    required String startDate,
    required String endDate,
    required String description,
    required bool paid,
    required int seatLimit,
    required int ageLimit,
    File? image,
    required double amount,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final uri = Uri.parse('$baseUrl/events');
    final request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name;
    request.fields['event_type_id'] = eventTypeId;
    request.fields['location'] = location;
    request.fields['start_time'] = startTime;
    request.fields['end_time'] = endTime;
    request.fields['start_date'] = startDate;
    request.fields['end_date'] = endDate;
    request.fields['description'] = description;
    request.fields['paid'] = paid ? '1' : '0';
    request.fields['seat_limit'] = seatLimit.toString();
    request.fields['age_limit'] = ageLimit.toString();
    request.fields['amount'] = amount.toString();
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          jsonResponse['message'] == 'Event created successfully') {
        return;
      } else {
        throw Exception(
            'Failed to create event: ${jsonResponse['message'] ?? response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchDirectChats({
    required int receiverId,
    required int page,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');
    final response = await _client.post(
      Uri.parse('$baseUrl/directchat-fetch'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'receiver_id': receiverId, 'page': page}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse['result']);
    } else {
      throw Exception('Failed to fetch direct chats: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchEventChat(int eventId) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');
    final response = await _client.post(
      Uri.parse('$baseUrl/eventchat-fetch'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'event_id': eventId}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse['result']);
    } else {
      throw Exception('Failed to fetch event chat: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> sendDirectMessage({
    required int receiverId,
    required String content,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/send-direct-message'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'receiver_id': receiverId, 'content': content}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to send direct message: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> sendEventMessage({
    required int eventId,
    required String content,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await _client.post(
      Uri.parse('$baseUrl/eventchat-send'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'event_id': eventId, 'content': content}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to send event message: ${response.body}');
    }
  }
}

class ResponseMessage {
  final String message;
  ResponseMessage({required this.message});
  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    return ResponseMessage(
      message: json['message'] ?? '',
    );
  }
}











// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import '../Models/eventDto.dart';
// import '../Models/userDto.dart';
// import 'auth_inspector.dart';
// class AuthService {
//   static const String baseUrl = 'https://molleadmin.com/api';
//   final storage = FlutterSecureStorage();
//   late final http.Client _client;
//   AuthService() {
//     _client = AuthInterceptor(http.Client(), storage);
//   }
//   Future<String?> getToken() async {
//     return await storage.read(key: 'auth_token');
//   }
//   Future<String> login(String email, String password) async {
//     final response = await _client.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Accept': 'application/json'},
//       body: {'email': email, 'password': password},
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       final result = jsonResponse['result'];
//       if (result == null || result['access_token'] == null) {
//         throw Exception(
//             'Login successful but token is missing in the response');
//       }
//       String token = result['access_token'];
//       await storage.write(key: 'auth_token', value: token);
//       return token;
//     } else {
//       throw Exception('Failed to login: ${response.body}');
//     }
//   }
//   Future<User> register({
//     required String fullname,
//     required String email,
//     required String password,
//     required String phoneNumber,
//     required String gender,
//     String? imagePath,
//   }) async {
//     final uri = Uri.parse('$baseUrl/register');
//     final request = http.MultipartRequest('POST', uri);
//     request.fields['fullname'] = fullname;
//     request.fields['email'] = email;
//     request.fields['password'] = password;
//     request.fields['phone_number'] = phoneNumber;
//     request.fields['gender'] = "Male";
//     if (imagePath != null && imagePath.isNotEmpty) {
//       request.files.add(await http.MultipartFile.fromPath('image', imagePath));
//     }
//     request.headers['Accept'] = 'application/json';
//     try {
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//       final jsonResponse = json.decode(responseBody);
//       if (response.statusCode == 200 ||
//           jsonResponse['message'] == 'User registered successfully') {
//         final result = jsonResponse['result'];
//         if (result != null) {
//           User user = User.fromJson(result);
//           if (user.accessToken != null) {
//             await storage.write(key: 'auth_token', value: user.accessToken!);
//           }
//           return user;
//         } else {
//           throw Exception(
//               'Registration successful, but user data is missing in the response');
//         }
//       } else {
//         throw Exception(
//             'Failed to register: ${jsonResponse['message'] ?? response.reasonPhrase}');
//       }
//     } catch (e) {
//       print('Exception occurred during registration: $e');
//       throw Exception('Failed to register: $e');
//     }
//   }
//   Future<void> logout() async {
//     final token = await getToken();
//     if (token != null) {
//       try {
//         await http.post(
//           Uri.parse('$baseUrl/logout'),
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         );
//       } catch (e) {
//         print('Error during logout API call: $e');
//       }
//     }
//     await storage.delete(key: 'auth_token');
//   }
//   Future<bool> checkUsername(String username) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('No token found');
//     }
//     final response = await _client.post(
//       Uri.parse('$baseUrl/check-username'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'username': username}),
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return jsonResponse['result'] == true;
//     } else {
//       throw Exception('Failed to check username: ${response.body}');
//     }
//   }
//   Future<void> setUsername(String username) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('No token found');
//     }
//     final response = await _client.post(
//       Uri.parse('$baseUrl/set-username'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'username': username}),
//     );
//     if (response.statusCode != 200) {
//       final errorResponse = json.decode(response.body);
//       throw Exception('Failed to set username: ${errorResponse['message']}');
//     }
//   }
//   Future<User> getUserProfile(int userId) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('No token found');
//     }
//     final response = await _client.post(
//       Uri.parse('$baseUrl/profile-other-user'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'user_id': userId}),
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return User.fromJson(jsonResponse['result']);
//     } else {
//       throw Exception('Failed to load user profile: ${response.body}');
//     }
//   }
//   Future<List<Event>> fetchEvents(int page) async {
//     final response = await _client.get(
//       Uri.parse('$baseUrl/events?page=$page'),
//       headers: {'Accept': 'application/json'},
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       final List<dynamic> eventsJson = jsonResponse['result']['data'] ?? [];

//       return eventsJson.map((json) => Event.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch events: ${response.body}');
//     }
//   }
//   Future<void> joinEvent(int eventId) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('User is not authenticated');
//     }
//     final response = await _client.post(
//       Uri.parse('$baseUrl/attend-event'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'event_id': eventId}),
//     );
//     final jsonResponse = json.decode(response.body);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       if (jsonResponse['message'] == 'Event joined successfully.') {
//         return;
//       } else {
//         print('Unexpected success response: ${jsonResponse['message']}');
//         return;
//       }
//     } else {
//       throw Exception('Failed to join event: ${jsonResponse['message']}');
//     }
//   }
//   Future<void> createEvent({
//     required String name,
//     required String eventTypeId,
//     required String location,
//     required String startTime,
//     required String endTime,
//     required String startDate,
//     required String endDate,
//     required String description,
//     required bool paid,
//     required int seatLimit,
//     required int ageLimit,
//     File? image,
//     required double amount,
//   }) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('No token found');
//     }
//     final uri = Uri.parse('$baseUrl/events');
//     final request = http.MultipartRequest('POST', uri);
//     request.fields['name'] = name;
//     request.fields['event_type_id'] = eventTypeId;
//     request.fields['location'] = location;
//     request.fields['start_time'] = startTime;
//     request.fields['end_time'] = endTime;
//     request.fields['start_date'] = startDate;
//     request.fields['end_date'] = endDate;
//     request.fields['description'] = description;
//     request.fields['paid'] = paid ? '1' : '0';
//     request.fields['seat_limit'] = seatLimit.toString();
//     request.fields['age_limit'] = ageLimit.toString();
//     request.fields['amount'] = amount.toString();
//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path));
//     }
//     request.headers['Accept'] = 'application/json';
//     request.headers['Authorization'] = 'Bearer $token';
//     try {
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//       final jsonResponse = json.decode(responseBody);
//       if ((response.statusCode == 200 || response.statusCode == 201) &&
//           jsonResponse['message'] == 'Event created successfully') {
//         return;
//       } else {
//         throw Exception(
//             'Failed to create event: ${jsonResponse['message'] ?? response.reasonPhrase}');
//       }
//     } catch (e) {
//       throw Exception('Failed to create event: $e');
//     }
//   }
//   Future<List<Map<String, dynamic>>> fetchDirectChats({
//     required int receiverId,
//     required int page,
//   }) async {
//     final token = await getToken();
//     if (token == null) throw Exception('No token found');
//     final response = await _client.post(
//       Uri.parse('$baseUrl/directchat-fetch'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'receiver_id': receiverId, 'page': page}),
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return List<Map<String, dynamic>>.from(jsonResponse['result']);
//     } else {
//       throw Exception('Failed to fetch direct chats: ${response.body}');
//     }
//   }
//   Future<List<Map<String, dynamic>>> fetchEventChat(int eventId) async {
//     final token = await getToken();
//     if (token == null) throw Exception('No token found');
//     final response = await _client.post(
//       Uri.parse('$baseUrl/eventchat-fetch'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'event_id': eventId}),
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return List<Map<String, dynamic>>.from(jsonResponse['result']);
//     } else {
//       throw Exception('Failed to fetch event chat: ${response.body}');
//     }
//   }
//   Future<Map<String, dynamic>> sendDirectMessage({
//     required int receiverId,
//     required String content,
//   }) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('No token found');
//     }
//     final response = await _client.post(
//       Uri.parse('$baseUrl/send-direct-message'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'receiver_id': receiverId, 'content': content}),
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return jsonResponse['result'];
//     } else {
//       throw Exception('Failed to send direct message: ${response.body}');
//     }
//   }
//   Future<Map<String, dynamic>> sendEventMessage({
//     required int eventId,
//     required String content,
//   }) async {
//     final token = await getToken();
//     if (token == null) {
//       throw Exception('No token found');
//     }
//     final response = await _client.post(
//       Uri.parse('$baseUrl/eventchat-send'),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'event_id': eventId, 'content': content}),
//     );
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return jsonResponse['result'];
//     } else {
//       throw Exception('Failed to send event message: ${response.body}');
//     }
//   }


// }
// class ResponseMessage {
//   final String message;
//   ResponseMessage({required this.message});
//   factory ResponseMessage.fromJson(Map<String, dynamic> json) {
//     return ResponseMessage(
//       message: json['message'] ?? '',
//     );
//   }
// }
