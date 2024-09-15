// // import 'package:flutter/material.dart';
// // import 'package:molle/Controllers/api_servie_login.dart';
// // import '../Chat/chat_screen.dart';
// //
// // class SingleEventScreen extends StatefulWidget {
// //   final String title;
// //   final String date;
// //   final String imagePath;
// //   final String location;
// //   final String time;
// //   final double price;
// //   final String members;
// //   final String description;
// //   final int eventId;
// //
// //   const SingleEventScreen({
// //     Key? key,
// //     required this.title,
// //     required this.date,
// //     required this.imagePath,
// //     required this.location,
// //     required this.time,
// //     required this.price,
// //     required this.members,
// //     required this.description,
// //     required this.eventId,
// //   }) : super(key: key);
// //
// //   @override
// //   _SingleEventScreenState createState() => _SingleEventScreenState();
// // }
// //
// // class _SingleEventScreenState extends State<SingleEventScreen> {
// //   final AuthService _authService = AuthService();
// //   bool isLiked = false;
// //   bool isReported = false;
// //   bool isLikeLoading = false;
// //   bool isReportLoading = false;
// //   bool isJoinLoading = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkEventStatus();
// //   }
// //
// //   Future<void> _checkEventStatus() async {
// //     try {
// //       final likedEvents = await _authService.getLikedEvents();
// //       final reportedEvents = await _authService.getReportedEvents();
// //
// //       setState(() {
// //         isLiked = likedEvents.any((event) => event['event_id'] == widget.eventId);
// //         isReported = reportedEvents.any((event) => event['reported_event_id'] == widget.eventId);
// //       });
// //     } catch (e) {
// //       print('Error checking event status: $e');
// //     }
// //   }
// //
// //   Future<void> _reportEvent() async {
// //     if (isReported || isReportLoading) return;
// //
// //     setState(() {
// //       isReportLoading = true;
// //     });
// //
// //     try {
// //       await _authService.reportEvent(widget.eventId);
// //       setState(() {
// //         isReported = true;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Event reported successfully.')),
// //       );
// //     } catch (e) {
// //       print('Error reporting event: $e');
// //       if (e.toString().contains('already been reported')) {
// //         setState(() {
// //           isReported = true;
// //         });
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('Failed to report event. Please try again.')),
// //         );
// //       }
// //     } finally {
// //       setState(() {
// //         isReportLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _likeEvent() async {
// //     if (isLikeLoading) return;
// //
// //     setState(() {
// //       isLikeLoading = true;
// //     });
// //
// //     try {
// //       await _authService.likeEvent(widget.eventId, !isLiked);
// //       setState(() {
// //         isLiked = !isLiked;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(isLiked ? 'Event liked successfully.' : 'Event unliked successfully.')),
// //       );
// //     } catch (e) {
// //       print('Error liking/unliking event: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Failed to like/unlike event. Please try again.')),
// //       );
// //     } finally {
// //       setState(() {
// //         isLikeLoading = false;
// //       });
// //     }
// //   }
// //
// //   Future<void> _joinEvent() async {
// //     if (isJoinLoading) return;
// //
// //     setState(() {
// //       isJoinLoading = true;
// //     });
// //
// //     try {
// //       print('Attempting to join event with ID: ${widget.eventId}');  // Debug log before the API call
// //       await _authService.joinEvent(widget.eventId);
// //       print('Join event API call succeeded.');  // Debug log after successful API call
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Event joined successfully.')),
// //       );
// //       // Navigate to the Chat screen
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => Chat()),
// //       );
// //     } catch (e) {
// //       print('Error joining event: $e');  // Debug log for error
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Failed to join event: ${e.toString()}')),
// //       );
// //     } finally {
// //       setState(() {
// //         isJoinLoading = false;
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Stack(
// //               children: [
// //                 Image.network(
// //                   widget.imagePath,
// //                   height: 400,
// //                   width: double.infinity,
// //                   fit: BoxFit.cover,
// //                 ),
// //                 Positioned(
// //                   top: 20,
// //                   left: 16,
// //                   child: GestureDetector(
// //                     onTap: () => Navigator.pop(context),
// //                     child: CircleAvatar(
// //                       backgroundColor: Colors.black.withOpacity(0.5),
// //                       child: const Icon(Icons.arrow_back, color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: 20,
// //                   right: 16,
// //                   child: CircleAvatar(
// //                     backgroundColor: Colors.black.withOpacity(0.5),
// //                     child: Icon(
// //                       isLiked ? Icons.favorite : Icons.favorite_border,
// //                       color: isLiked ? Colors.red : Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             Expanded(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       widget.title,
// //                       style: const TextStyle(
// //                         fontSize: 15,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.calendar_today, size: 13, color: Colors.grey),
// //                         const SizedBox(width: 4),
// //                         Text(widget.date),
// //                         const SizedBox(width: 16),
// //                         const Icon(Icons.location_on, size: 13, color: Colors.grey),
// //                         const SizedBox(width: 4),
// //                         Text(widget.location),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Row(
// //                       children: [
// //                         const Icon(Icons.access_time, size: 13, color: Colors.grey),
// //                         const SizedBox(width: 4),
// //                         Text(widget.time),
// //                         const SizedBox(width: 15),
// //                         const Icon(Icons.people, size: 13, color: Colors.grey),
// //                         const SizedBox(width: 4),
// //                         Text(widget.members),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     const Text(
// //                       'Description',
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Expanded(
// //                       child: SingleChildScrollView(
// //                         child: Text(
// //                           widget.description,
// //                           style: const TextStyle(fontSize: 16),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     Row(
// //                       children: [
// //                         ElevatedButton(
// //                           onPressed: isReported ? null : _reportEvent,
// //                           child: isReportLoading
// //                               ? const SizedBox(
// //                             width: 20,
// //                             height: 20,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                             ),
// //                           )
// //                               : Text(isReported ? 'Reported' : 'Report Event'),
// //                         ),
// //                         const Spacer(),
// //                         ElevatedButton(
// //                           onPressed: _likeEvent,
// //                           child: isLikeLoading
// //                               ? const SizedBox(
// //                             width: 20,
// //                             height: 20,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                             ),
// //                           )
// //                               : Text(isLiked ? 'Liked' : 'Like Event'),
// //                         ),
// //                         const Spacer(),
// //                         ElevatedButton(
// //                           onPressed: isJoinLoading ? null : _joinEvent,
// //                           child: isJoinLoading
// //                               ? const SizedBox(
// //                             width: 20,
// //                             height: 20,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                             ),
// //                           )
// //                               : const Text('Join Now'),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.purple,
// //                             padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(15),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:molle/Controllers/api_servie_login.dart';
// import '../../../../Models/userDto.dart';
// import '../Chat/chat_screen.dart';
//
// class SingleEventScreen extends StatefulWidget {
//   final String title;
//   final String date;
//   final String imagePath;
//   final String location;
//   final String time;
//   final double price;
//   final String members;
//   final String description;
//   final int eventId;
//
//   const SingleEventScreen({
//     Key? key,
//     required this.title,
//     required this.date,
//     required this.imagePath,
//     required this.location,
//     required this.time,
//     required this.price,
//     required this.members,
//     required this.description,
//     required this.eventId,
//   }) : super(key: key);
//
//   @override
//   _SingleEventScreenState createState() => _SingleEventScreenState();
// }
//
// class _SingleEventScreenState extends State<SingleEventScreen> {
//   final AuthService _authService = AuthService();
//   bool isLiked = false;
//   bool isReported = false;
//   bool isLikeLoading = false;
//   bool isReportLoading = false;
//   bool isJoinLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkEventStatus();
//   }
//
//   Future<void> _checkEventStatus() async {
//     try {
//       final likedEvents = await _authService.getLikedEvents();
//       final reportedEvents = await _authService.getReportedEvents();
//
//       setState(() {
//         isLiked =
//             likedEvents.any((event) => event['event_id'] == widget.eventId);
//         isReported = reportedEvents
//             .any((event) => event['reported_event_id'] == widget.eventId);
//       });
//     } catch (e) {
//       print('Error checking event status: $e');
//     }
//   }
//
//   Future<void> _reportEvent() async {
//     if (isReported || isReportLoading) return;
//
//     setState(() {
//       isReportLoading = true;
//     });
//
//     try {
//       await _authService.reportEvent(widget.eventId);
//       setState(() {
//         isReported = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event reported successfully.')),
//       );
//     } catch (e) {
//       print('Error reporting event: $e');
//       if (e.toString().contains('already been reported')) {
//         setState(() {
//           isReported = true;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Failed to report event. Please try again.')),
//         );
//       }
//     } finally {
//       setState(() {
//         isReportLoading = false;
//       });
//     }
//   }
//
//   Future<void> _likeEvent() async {
//     if (isLikeLoading) return;
//
//     setState(() {
//       isLikeLoading = true;
//     });
//
//     try {
//       await _authService.likeEvent(widget.eventId, !isLiked);
//       setState(() {
//         isLiked = !isLiked;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(isLiked
//                 ? 'Event liked successfully.'
//                 : 'Event unliked successfully.')),
//       );
//     } catch (e) {
//       print('Error liking/unliking event: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Failed to like/unlike event. Please try again.')),
//       );
//     } finally {
//       setState(() {
//         isLikeLoading = false;
//       });
//     }
//   }
//
//   Future<void> _joinEvent() async {
//     if (isJoinLoading) return;
//
//     setState(() {
//       isJoinLoading = true;
//     });
//
//     try {
//       print('Attempting to join event with ID: ${widget.eventId}');
//       await _authService.joinEvent(widget.eventId);
//       print('Join event API call succeeded.');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event joined successfully.')),
//       );
//       // Navigate to the Chat screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const Chat(), // Ensure 'user.id' is an int
//         ),
//       );
//     } catch (e) {
//       print('Error joining event: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to join event: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isJoinLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Improved Image Section with no white space and larger image
//             Stack(
//               children: [
//                 // Increased height for the image to reduce the white space
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height *
//                       0.4, // Increase height to 40% of screen height
//                   width: double.infinity,
//                   child: Image.network(
//                     widget.imagePath,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[200],
//                         child: const Center(
//                           child: Icon(Icons.broken_image,
//                               size: 50, color: Colors.grey),
//                         ),
//                       );
//                     },
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   top: 20,
//                   left: 16,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.black.withOpacity(0.5),
//                       child: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 20,
//                   right: 16,
//                   child: GestureDetector(
//                     onTap: _likeEvent,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.black.withOpacity(0.5),
//                       child: Icon(
//                         isLiked ? Icons.favorite : Icons.favorite_border,
//                         color: isLiked ? Colors.red : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Details and Actions Section
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today,
//                             size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.date),
//                         const SizedBox(width: 16),
//                         const Icon(Icons.location_on,
//                             size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Flexible(
//                           child: Text(widget.location,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.access_time,
//                             size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.time),
//                         const SizedBox(width: 15),
//                         const Icon(Icons.people, size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.members),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Text(
//                           widget.description,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Action Buttons with improved layout and overflow handling
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: isReported ? null : _reportEvent,
//                             child: isReportLoading
//                                 ? const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white),
//                                     ),
//                                   )
//                                 : Text(
//                                     isReported ? 'Reported' : 'Report Event'),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: isJoinLoading ? null : _joinEvent,
//                             child: isJoinLoading
//                                 ? const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white),
//                                     ),
//                                   )
//                                 : const Text(
//                                     'Join Now',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.purple,
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:molle/Controllers/api_servie_login.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../../../../Models/userDto.dart';
// import '../Chat/chat_screen.dart';

// class SingleEventScreen extends StatefulWidget {
//   final String title;
//   final String date;
//   final String imagePath;
//   final String location;
//   final String time;
//   final double price;
//   final String members;
//   final String description;
//   final int eventId;

//   // final int minimumAge; // Add minimum age property

//   const SingleEventScreen({
//     Key? key,
//     required this.title,
//     required this.date,
//     required this.imagePath,
//     required this.location,
//     required this.time,
//     required this.price,
//     required this.members,
//     required this.description,
//     required this.eventId,
//     // required this.minimumAge, // Add minimum age to constructor
//   }) : super(key: key);

//   @override
//   _SingleEventScreenState createState() => _SingleEventScreenState();
// }

// class _SingleEventScreenState extends State<SingleEventScreen> {
//   final AuthService _authService = AuthService();
//   bool isLiked = false;
//   bool isReported = false;
//   bool isLikeLoading = false;
//   bool isReportLoading = false;
//   bool isJoinLoading = false;
//   late Razorpay _razorpay;

//   @override
//   void initState() {
//     super.initState();
//     _checkEventStatus();

//     // Initialize Razorpay
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//   void _openCheckout() {
//     var options = {
//       'key': 'rzp_live_dqI5SlUnHw3ykT', // Replace with your Razorpay key
//       'amount': (widget.price * 100).toInt(), // Razorpay expects amount in paise
//       'name': widget.title,
//       'description': 'Entry fee for the event',
//       'prefill': {'contact': '', 'email': ''}, // Optionally prefill user's data
//       'external': {
//         'wallets': ['paytm']
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     // Handle successful payment
//     print('Payment Successful: ${response.paymentId}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Payment successful. You have joined the event.')),
//     );
//     _joinEvent();
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Handle payment error
//     print('Payment Error: ${response.code} | ${response.message}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment failed: ${response.message}')),
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     // Handle external wallet payment
//     print('External Wallet: ${response.walletName}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment via ${response.walletName} successful.')),
//     );
//   }
//   Future<void> _checkEventStatus() async {
//     try {
//       final likedEvents = await _authService.getLikedEvents();
//       final reportedEvents = await _authService.getReportedEvents();

//       setState(() {
//         isLiked =
//             likedEvents.any((event) => event['event_id'] == widget.eventId);
//         isReported = reportedEvents
//             .any((event) => event['reported_event_id'] == widget.eventId);
//       });
//     } catch (e) {
//       print('Error checking event status: $e');
//     }
//   }

//   Future<void> _reportEvent() async {
//     if (isReported || isReportLoading) return;

//     setState(() {
//       isReportLoading = true;
//     });

//     try {
//       await _authService.reportEvent(widget.eventId);
//       setState(() {
//         isReported = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event reported successfully.')),
//       );
//     } catch (e) {
//       print('Error reporting event: $e');
//       if (e.toString().contains('already been reported')) {
//         setState(() {
//           isReported = true;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Failed to report event. Please try again.')),
//         );
//       }
//     } finally {
//       setState(() {
//         isReportLoading = false;
//       });
//     }
//   }

//   Future<void> _likeEvent() async {
//     if (isLikeLoading) return;

//     setState(() {
//       isLikeLoading = true;
//     });

//     try {
//       await _authService.likeEvent(widget.eventId, !isLiked);

//       setState(() {
//         isLiked = !isLiked;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(isLiked
//                 ? 'Event liked successfully.'
//                 : 'Event unliked successfully.')),
//       );
//     } catch (e) {
//       print('Error liking/unliking event: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Failed to like/unlike event. Please try again.')),
//       );
//     } finally {
//       setState(() {
//         isLikeLoading = false;
//       });
//     }
//   }

//   Future<void> _joinEvent() async {
//     if (isJoinLoading) return;

//     setState(() {
//       isJoinLoading = true;
//     });

//     try {
//       await _authService.joinEvent(widget.eventId);
//       _openCheckout();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Event joined successfully.')),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) =>  Chat(eventId: widget.eventId,)),
//       );
//     } catch (e) {
//       print('Error joining event: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to join event: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isJoinLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 Image.network(
//                   widget.imagePath,
//                   height: 400,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   top: 20,
//                   left: 16,
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.black.withOpacity(0.5),
//                       child: const Icon(Icons.arrow_back, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 20,
//                   right: 16,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.black.withOpacity(0.5),
//                     child: Icon(
//                       isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: isLiked ? Colors.red : Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.title,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today,
//                             size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.date),
//                         const SizedBox(width: 16),
//                         const Icon(Icons.location_on,
//                             size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.location),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.access_time,
//                             size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.time),
//                         const SizedBox(width: 15),
//                         const Icon(Icons.people, size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         Text(widget.members),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.person, size: 13, color: Colors.grey),
//                         const SizedBox(width: 4),
//                         // Text('Minimum Age: ${widget.minimumAge}'),
//                         // Display minimum age
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Text(
//                           widget.description,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: isReported ? null : _reportEvent,
//                           child: isReportLoading
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : Text(isReported ? 'Reported' : 'Report Event'),
//                         ),
//                         const Spacer(),
//                         ElevatedButton(
//                           onPressed: _likeEvent,
//                           child: isLikeLoading
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : Text(isLiked ? 'Liked' : 'Like Event'),
//                         ),
//                         const Spacer(),
//                         ElevatedButton(
//                           onPressed: isJoinLoading ? null : _joinEvent,
//                           child: isJoinLoading
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : const Text('Join Now',
//                             style: TextStyle(color: Colors.white),),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.purple,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//////////////////////////////////////////////     new  //////////////////

import 'package:flutter/material.dart';
import 'package:molle/Controllers/api_servie_login.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../Chat/chat_screen.dart';

class SingleEventScreen extends StatefulWidget {
  final String title;
  final String date;
  final String imagePath;
  final String location;
  final String time;
  final double price;
  final String members;
  final String description;
  final int eventId;

  // final int minimumAge; // Add minimum age property

  const SingleEventScreen({
    Key? key,
    required this.title,
    required this.date,
    required this.imagePath,
    required this.location,
    required this.time,
    required this.price,
    required this.members,
    required this.description,
    required this.eventId,
    // required this.minimumAge, // Add minimum age to constructor
  }) : super(key: key);

  @override
  _SingleEventScreenState createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  final AuthService _authService = AuthService();
  bool isLiked = false;
  bool isReported = false;
  bool isLikeLoading = false;
  bool isReportLoading = false;
  bool isJoinLoading = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _checkEventStatus();

    // Initialize Razorpay
    // _razorpay = Razorpay();
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  //  void _openCheckout() {
  //   var options = {
  //     'key': 'rzp_live_dqI5SlUnHw3ykT', // Replace with your Razorpay key
  //     'amount': (widget.price * 100).toInt(), // Razorpay expects amount in paise
  //     'name': widget.title,
  //     'description': 'Entry fee for the event',
  //     'prefill': {'contact': '', 'email': ''}, // Optionally prefill user's data
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }



  Future<void> _checkEventStatus() async {
    try {
      final likedEvents = await _authService.getLikedEvents();
      final reportedEvents = await _authService.getReportedEvents();

      setState(() {
        isLiked =
            likedEvents.any((event) => event['event_id'] == widget.eventId);
        isReported = reportedEvents
            .any((event) => event['reported_event_id'] == widget.eventId);
      });
    } catch (e) {
      print('Error checking event status: $e');
    }
  }

  Future<void> _reportEvent() async {
    if (isReported || isReportLoading) return;

    setState(() {
      isReportLoading = true;
    });

    try {
      await _authService.reportEvent(widget.eventId);
      setState(() {
        isReported = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event reported successfully.')),
      );
    } catch (e) {
      print('Error reporting event: $e');
      if (e.toString().contains('already been reported')) {
        setState(() {
          isReported = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to report event. Please try again.')),
        );
      }
    } finally {
      setState(() {
        isReportLoading = false;
      });
    }
  }

  Future<void> _likeEvent() async {
    if (isLikeLoading) return;

    setState(() {
      isLikeLoading = true;
    });

    try {
      await _authService.likeEvent(widget.eventId, !isLiked);

      setState(() {
        isLiked = !isLiked;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isLiked
                ? 'Event liked successfully.'
                : 'Event unliked successfully.')),
      );
    } catch (e) {
      print('Error liking/unliking event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to like/unlike event. Please try again.')),
      );
    } finally {
      setState(() {
        isLikeLoading = false;
      });
    }
  }

  

  Razorpay razorpay = Razorpay();

  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.imagePath,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(widget.date),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(widget.location),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(widget.time),
                        const SizedBox(width: 15),
                        const Icon(Icons.people, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(widget.members),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        // Text('Minimum Age: ${widget.minimumAge}'),
                        // Display minimum age
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: isReported ? null : _reportEvent,
                          child: isReportLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(isReported ? 'Reported' : 'Report Event'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _likeEvent,
                          child: isLikeLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(isLiked ? 'Liked' : 'Like Event'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: isJoinLoading ? null : _joinEvent,
                          child: isJoinLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Join Now',
                            style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        
                        // ElevatedButton(
                        //     onPressed: () {
                        //     //  _openCheckout();
                        //       var options = {
                        //         // 'key': 'rzp_test_GcZZFDPP0jHtC4',
                        //         'key': 'rzp_live_dqI5SlUnHw3ykT',
                        //         'amount': (widget.price * 100),
                        //         'name': widget.title,
                        //         'description': 'Entry fee for the event',
                        //         'prefill': {'contact': '', 'email': ''},
                        //         'external': {'wallets': ['paytm']},
                        //       };
                        //       razorpay.open(options);
                        //     },
                        //     child: Text("Join Now"))
                        
                        
                        // ElevatedButton(
                        //     onPressed: () {
                        //     //  _openCheckout();
                        //       var options = {
                        //         // 'key': 'rzp_test_GcZZFDPP0jHtC4',
                        //         'key': 'rzp_live_dqI5SlUnHw3ykT',
                        //         'amount': (widget.price * 100),
                        //         'name': widget.title,
                        //         'description': 'Entry fee for the event',
                        //         'prefill': {'contact': '', 'email': ''},
                        //         'external': {'wallets': ['paytm']},
                        //       };
                        //       razorpay.open(options);
                        //     },
                        //     child: Text("Join Now"))
                      ],
                      
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Successful: ${response.paymentId}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Payment successful. You have joined the event.')),
    );
    _joinEvent();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} | ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment via ${response.walletName} successful.')),
    );
  }

  // Future<void> _joinEvent() async {
  //   if (isJoinLoading) return;

  //   setState(() {
  //     isJoinLoading = true;
  //   });

  //   try {
  //     await _authService.joinEvent(widget.eventId);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Event joined successfully.')),
  //     );
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => Chat(
  //                 eventId: widget.eventId,
  //               )),
  //     );
  //   } catch (e) {
  //     print('Error joining event: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to join event: ${e.toString()}')),
  //     );
  //   } finally {
  //     setState(() {
  //       isJoinLoading = false;
  //     });
  //   }
  // }
  Future<void> _joinEvent() async {
  if (isJoinLoading) return;

  setState(() {
    isJoinLoading = true;
  });

  // Razorpay payment options
  var options = {
    'key': 'rzp_live_dqI5SlUnHw3ykT', // Your live Razorpay key
    'amount': (widget.price * 100).toInt(), // Amount in paise (100 paise = 1 INR)
    'name': widget.title,
    'description': 'Entry fee for the event',
    'prefill': {'contact': '', 'email': ''},
    'external': {'wallets': ['paytm']},
  };

  try {
    // Open Razorpay payment
    razorpay.open(options);

    // Listen to Razorpay payment success or failure
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) async {
      // Payment succeeded, now join the event
      try {
        await _authService.joinEvent(widget.eventId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event joined successfully.')),
        );

        // Navigate to chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(eventId: widget.eventId),
          ),
        );
      } catch (e) {
        print('Error joining event: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join event: ${e.toString()}')),
        );
      }
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${response.toString()}')),
      );
    });
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to initiate payment: ${e.toString()}')),
    );
  } finally {
    setState(() {
      isJoinLoading = false;
    });
  }
}


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }
}
