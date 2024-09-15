//
// import 'package:flutter/material.dart';
// import 'package:molle/Views/Screens/Auth/phoneverify.dart';
// import 'package:molle/Views/Screens/Auth/login.dart';
// import 'package:molle/Controllers/api_servie_login.dart';
// import 'package:molle/Views/Screens/Auth/select_username.dart';
//
// import '../Home/BottomNav/bottomnav.dart';
// import '../Home/home.dart';
//
// class Signup extends StatefulWidget {
//   const Signup({super.key});
//
//   @override
//   State<Signup> createState() => _SignupState();
// }
//
// class _SignupState extends State<Signup> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullnameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _genderController = TextEditingController();
//   final AuthService _authService = AuthService();
//
//   bool _isLoading = false;
//
//   // Initial gender value
//   String _selectedGender = 'Male';
//
//   void _signup() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
//
//       try {
//         // Convert gender to 'M' or 'F'
//         String genderToSend = _selectedGender == 'Male'
//             ? 'M'
//             : _selectedGender == 'Female'
//                 ? 'F'
//                 : 'O'; // Use 'O' for 'Other'
//
//         print('Attempting to register user with the following details:');
//         print('Full Name: ${_fullnameController.text}');
//         print('Email: ${_emailController.text}');
//         print('Phone Number: ${_phoneNumberController.text}');
//         print('Gender: $genderToSend');
//
//         final user = await _authService.register(
//           fullname: _fullnameController.text,
//           email: _emailController.text,
//           password: _passwordController.text,
//           phoneNumber: _phoneNumberController.text,
//           gender: genderToSend,
//           imagePath: '',
//         );
//
//         print('Registration successful: ${user.fullname}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Registration successful: ${user.fullname}')),
//         );
//
//         // Navigate to the home screen
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => BottomNav()),
//         );
//       } catch (e) {
//         print('Signup failed with error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Signup failed: ${e.toString()}')),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//           print('Signup process complete.');
//         });
//       }
//     } else {
//       print('Form validation failed.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Building Signup widget');
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Image.asset(
//             'assets/club.jpg',
//             fit: BoxFit.cover,
//           ),
//           Container(
//             color: Colors.black.withOpacity(0.6),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(
//                         height: 50,
//                       ),
//                       const Text(
//                         'Signup Now!',
//                         style: TextStyle(
//                           fontSize: 17,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 50),
//                       _buildTextField(
//                         controller: _fullnameController,
//                         hintText: 'Full Name',
//                         icon: Icons.person,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _emailController,
//                         hintText: 'Email',
//                         icon: Icons.email,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _phoneNumberController,
//                         hintText: 'Phone Number',
//                         icon: Icons.phone,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildTextField(
//                         controller: _passwordController,
//                         hintText: 'Password',
//                         icon: Icons.lock,
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 20),
//                       _buildGenderField(),
//                       const SizedBox(height: 100),
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             colors: [
//                               Colors.purple,
//                               Colors.pink,
//                               Colors.deepPurple,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _signup,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.transparent,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 50, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             shadowColor: Colors.transparent,
//                           ),
//                           child: Ink(
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Colors.transparent,
//                                   Colors.transparent
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Container(
//                               constraints: const BoxConstraints(
//                                 maxWidth: 200,
//                                 minHeight: 23.0,
//                               ),
//                               alignment: Alignment.center,
//                               child: _isLoading
//                                   ? CircularProgressIndicator()
//                                   : const Text(
//                                       'Signup',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // Add some space between the button and the text
//                       _buildLoginPrompt(context),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     bool obscureText = false,
//   }) {
//     return Container(
//       height: 50,
//       width: 320,
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.white54),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.2),
//           prefixIcon: Icon(icon, color: Colors.white),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGenderField() {
//     return Container(
//       height: 50,
//       width: 320,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: DropdownButtonFormField<String>(
//         decoration: const InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.transparent),
//           ),
//         ),
//         style: const TextStyle(color: Colors.white),
//         dropdownColor: Colors.black87,
//         iconEnabledColor: Colors.white,
//         value: _selectedGender,
//         onChanged: (newValue) {
//           setState(() {
//             _selectedGender = newValue!;
//             print('Selected gender: $_selectedGender');
//           });
//         },
//         items: <String>['Male', 'Female', 'Other']
//             .map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(
//             value: value,
//             child: Text(value),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   Widget _buildLoginPrompt(BuildContext context) {
//     print('Building login prompt');
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           const Text(
//             "Already have an account?",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               print('Navigating to LoginScreen');
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LoginScreen(),
//                 ),
//               );
//             },
//             child: const Text(
//               "Sign in now",
//               style: TextStyle(
//                 color: Colors.purpleAccent,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:molle/Views/Screens/Auth/phoneverify.dart';
import 'package:molle/Views/Screens/Auth/login.dart';
import 'package:molle/Controllers/api_servie_login.dart';
import 'package:molle/Views/Screens/Auth/select_username.dart';
import '../Home/BottomNav/bottomnav.dart';
import '../Home/Privacy/privacy_policy.dart';
import '../Home/home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _genderController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isTermsAccepted = false; // New: Checkbox for terms acceptance

  // Initial gender value
  String _selectedGender = 'Male';

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      if (!_isTermsAccepted) {
        // Check if the user has accepted the terms
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'You must accept the terms and conditions to continue.')),
        );
        return; // Stop signup if terms are not accepted
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Convert gender to 'M' or 'F'
        // String genderToSend = _selectedGender == 'Male'
        //     ? 'M'
        //     : _selectedGender == 'Female'
        //         ? 'F'
        //         : 'O'; // Use 'O' for 'Other'

        print('Attempting to register user with the following details:');
        print('Full Name: ${_fullnameController.text}');
        print('Email: ${_emailController.text}');
        print('Phone Number: ${_phoneNumberController.text}');
        // print('Gender: $_genderController');

        final user = await _authService.register(
          fullname: _fullnameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phoneNumber: _phoneNumberController.text,
          gender: _genderController.text,
          imagePath: '',
        );

        print('Registration successful: ${user.fullname}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful: ${user.fullname}')),
        );

        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNav()),
        );
      } catch (e) {
        print('Signup failed with error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
          print('Signup process complete.');
        });
      }
    } else {
      print('Form validation failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building Signup widget');
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      const Text(
                        'Signup Now!',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildTextField(
                        controller: _fullnameController,
                        hintText: 'Full Name',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _phoneNumberController,
                        hintText: 'Phone Number',
                        icon: Icons.phone,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      _buildGenderField(),
                      const SizedBox(height: 20),
                      _buildTermsCheckbox(), // New: Add checkbox here
                      const SizedBox(height: 100),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.purple,
                              Colors.pink,
                              Colors.deepPurple,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signup,
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
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 200,
                                minHeight: 23.0,
                              ),
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : const Text(
                                      'Signup',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLoginPrompt(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      height: 50,
      width: 320,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
      ),
    );
  }

  Widget _buildGenderField() {
    return Container(
      height: 50,
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.black87,
        iconEnabledColor: Colors.white,
        value: _selectedGender,
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue!;
            print('Selected gender: $_selectedGender');
          });
        },
        items: <String>['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Center(
      child: CheckboxListTile(
        value: _isTermsAccepted,
        onChanged: (bool? newValue) {
          setState(() {
            _isTermsAccepted = newValue ?? false;
          });
        },
        title: Row(
          children: [
            const Text(
              'I accept the ',
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to the Terms and Conditions page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Privacy(),
                  ),
                );
              },
              child: const Text(
                'Terms and Conditions',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.purpleAccent,
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    print('Building login prompt');
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Already have an account?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              print('Navigating to LoginScreen');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: const Text(
              "Sign in now",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
