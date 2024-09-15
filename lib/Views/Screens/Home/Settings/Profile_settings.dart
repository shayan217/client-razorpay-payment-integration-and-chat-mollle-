import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Import image package for resizing
import 'package:molle/Controllers/api_servie_login.dart';
import '../../../../Models/userDto.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final Function(User) onProfileUpdated;

  const ProfileSettingsScreen({super.key, required this.onProfileUpdated});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  String? _profileImage;
  String? _gender;
  bool _isLoading = true;
  bool _isUsernameEdited = false;
  bool _isUnique = false;
  bool _isCheckingUsername = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  File? _imageFile; // To store the picked image file

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  String? _normalizeUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    if (!imageUrl.startsWith('https://molleadmin.com/public/assets/source/')) {
      return 'https://molleadmin.com/public/assets/source/$imageUrl';
    }
    return imageUrl;
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _authService.getProfile();
      setState(() {
        _usernameController.text = user.username ?? '';
        _emailController.text = user.email;
        _fullNameController.text = user.fullname;
        _profileImage = _normalizeUrl(user.image);
        _gender = user.gender;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load user profile: $e');
    }
  }

  Future<void> _checkUsernameUnique() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _errorMessage = 'Username cannot be empty';
        _isUnique = false;
      });
      return;
    }

    setState(() {
      _isCheckingUsername = true;
      _errorMessage = null;
    });

    try {
      bool isUnique = await _authService.checkUsername(username);
      setState(() {
        _isUnique = isUnique;
        _errorMessage = isUnique ? null : 'Username is taken';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error checking username: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isCheckingUsername = false;
      });
    }
  }

  Future<void> _setUsername() async {
    final username = _usernameController.text.trim();
    if (!_isUnique || username.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.setUsername(username);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username set successfully')),
      );
      setState(() {
        _isLoading = false;
        _isUsernameEdited = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error setting username: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Resize and compress the image before uploading
      _resizeAndUploadImage(_imageFile!);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _resizeAndUploadImage(File image) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load the image
      final bytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      // Resize the image to make sure it's smaller than 2048 KB
      final resizedImage = img.copyResize(decodedImage!, width: 500);

      // Compress the image to ensure it is under 2048 KB
      final compressedImage = img.encodeJpg(resizedImage, quality: 85);

      // Save the compressed image to a temporary file
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/resized_image.jpg')
        ..writeAsBytesSync(compressedImage);

      // Upload the resized and compressed image
      final updatedUser = await _authService.updateProfileImage(tempFile);

      setState(() {
        _profileImage = _normalizeUrl(updatedUser.image);
        _isLoading = false;
      });

      widget.onProfileUpdated(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image updated successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to upload image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        leading: IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: _isUsernameEdited && _isUnique ? _setUsername : null,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null &&
                                  _profileImage!.isNotEmpty
                              ? NetworkImage(_profileImage!)
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                          onBackgroundImageError: (_, __) {
                            setState(() {
                              _profileImage = null;
                            });
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 15,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                              onPressed: _pickImage, // Handle image upload
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildCard(
                    child: buildTextField(
                      'Username',
                      _usernameController,
                      onChanged: (value) {
                        setState(() {
                          _isUsernameEdited = true;
                          _isUnique = false;
                        });
                      },
                      suffixIcon: _isCheckingUsername
                          ? const CircularProgressIndicator()
                          : _isUnique
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: _checkUsernameUnique,
                                ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildCard(
                    child: buildTextField(
                      'Email',
                      _emailController,
                      enabled: false,
                      suffixIcon:
                          const Icon(Icons.verified, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'After changing your email address you need to repeat the verification steps by clicking on the verification link sent by noreply@mg.wevent.fun. Until then your email change will be flagged as unverified.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildCard(
                    child: buildTextField(
                      'Full Name',
                      _fullNameController,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildCard(
                    child: buildTextField(
                      'About me',
                      _aboutMeController,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gender',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Male',
                                      style: TextStyle(fontSize: 10)),
                                  leading: Radio(
                                    value: 'Male',
                                    groupValue: _gender,
                                    onChanged: null,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Female',
                                      style: TextStyle(fontSize: 10)),
                                  leading: Radio(
                                    value: 'Female',
                                    groupValue: _gender,
                                    onChanged: null,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Other',
                                      style: TextStyle(fontSize: 10)),
                                  leading: Radio(
                                    value: 'Other',
                                    groupValue: _gender,
                                    onChanged: null,
                                  ),
                                ),
                              ),
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

  Widget buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {Widget? suffixIcon, bool enabled = true, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        border: InputBorder.none,
      ),
    );
  }
}
