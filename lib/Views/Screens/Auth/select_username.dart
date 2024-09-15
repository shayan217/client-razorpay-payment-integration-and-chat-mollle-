import 'package:flutter/material.dart';
import 'package:molle/Controllers/api_servie_login.dart';
import 'login.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}
class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final AuthService _authService = AuthService();
  int _usernameLength = 0;
  bool _isUnique = false;
  bool _isLoading = false;
  String? _errorMessage;
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
      _isLoading = true;
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
        _isLoading = false;
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error setting username: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/club.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: const SizedBox.shrink(),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hi User!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What do you want your username to be?',
                    style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usernameController,
                    maxLength: 20,
                    onChanged: (text) {
                      setState(() {
                        _usernameLength = text.length;
                        _errorMessage = null;
                        _isUnique = false;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: const TextStyle(color: Colors.grey),
                      counterText: '$_usernameLength/20',
                      counterStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      errorText: _errorMessage,
                      suffixIcon: _isUnique
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                  ),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
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
                        onPressed: _checkUsernameUnique,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Check Username',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
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
                        onPressed: _isUnique ? _setUsername : null,
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
                              colors: [Colors.transparent, Colors.transparent],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                              minHeight: 23.0,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
