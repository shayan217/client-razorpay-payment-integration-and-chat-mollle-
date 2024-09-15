// import 'eventDto.dart';
//
// class User {
//   final int id;
//   final String fullname;
//   final String email;
//   final String phoneNumber;
//   final String gender;
//   final String? image;
//   final String? username;
//   final bool phoneVerified;
//   final bool isVerified;
//   final List<Event> eventsByUser;
//   final List<Event> eventsAttended;
//   final List<Event> eventsLiked;
//
//   User({
//     required this.id,
//     required this.fullname,
//     required this.email,
//     required this.phoneNumber,
//     required this.gender,
//     this.image,
//     required this.username,
//     required this.phoneVerified,
//     required this.isVerified,
//     required this.eventsByUser,
//     required this.eventsAttended,
//     required this.eventsLiked,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] ?? 0,
//       fullname: json['fullname'] ?? '',
//       email: json['email'] ?? '',
//       phoneNumber: json['phone_number'] ?? '',
//       gender: json['gender'] ?? '',
//       image: json['image'],
//       username: json['username'] ?? '',
//       phoneVerified: json['phone_verified'] == 1,
//       isVerified: json['is_verified'] == 1,
//       eventsByUser: (json['event_by_user'] as List<dynamic>?)
//           ?.map((e) => Event.fromJson(e))
//           .toList() ??
//           [],
//       eventsAttended: (json['event_attend'] as List<dynamic>?)
//           ?.map((e) => Event.fromJson(e))
//           .toList() ??
//           [],
//       eventsLiked: (json['event_liked'] as List<dynamic>?)
//           ?.map((e) => Event.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
// }

import 'eventDto.dart';

class User {
  final int id;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String gender;
  final String? image;
  final String? username;
  final bool phoneVerified;
  final bool isVerified;
  final List<Event> eventsByUser;
  final List<Event> eventsAttended;
  final List<Event> eventsLiked;
  final String? accessToken; // Add the accessToken field

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.image,
    this.username,
    required this.phoneVerified,
    required this.isVerified,
    required this.eventsByUser,
    required this.eventsAttended,
    required this.eventsLiked,
    this.accessToken, // Initialize the accessToken field
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'],
      username: json['username'],
      phoneVerified: json['phone_verified'] == 1,
      isVerified: json['is_verified'] == 1,
      eventsByUser: (json['event_by_user'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e))
              .toList() ??
          [],
      eventsAttended: (json['event_attend'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e))
              .toList() ??
          [],
      eventsLiked: (json['event_liked'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e))
              .toList() ??
          [],
      accessToken: json['access_token'], // Parse the accessToken from JSON
    );
  }
}
