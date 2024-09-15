import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../Utils/constants.dart';
import 'package:molle/Controllers/api_servie_login.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../Utils/constants.dart';
import 'package:molle/Controllers/api_servie_login.dart';

class Document extends StatefulWidget {
  @override
  _DocumentState createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService(); // Instantiate your AuthService
  bool _isFrontUploaded = false; // To track the upload stage
  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage(bool isFront) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
    }
  }

  // Function to handle the upload of documents
  Future<void> _uploadDocuments() async {
    if (_frontImage == null || _backImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both front and back images.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.uploadDocuments(_frontImage!, _backImage!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Documents uploaded successfully!')),
      );

      // Navigate back to create event screen after successful upload
      Navigator.pop(context); // Pop this screen and go back to the event creation screen

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload documents: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Upload Documents',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: ColorConstants.mainColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Show either front or back upload UI based on the state
              !_isFrontUploaded ? _buildUploadUI(true) : _buildUploadUI(false),
              const SizedBox(height: 20),
              // Button to proceed to the next step or finish the upload
              ElevatedButton(
                onPressed: () {
                  if (!_isFrontUploaded && _frontImage != null) {
                    setState(() {
                      _isFrontUploaded = true;
                    });
                  } else if (_isFrontUploaded && _backImage != null) {
                    _uploadDocuments();
                  }
                },
                child: Text(
                  !_isFrontUploaded ? 'Next' : 'Finish',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: ColorConstants.mainColor,
                ),
              ),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build the upload UI
  Widget _buildUploadUI(bool isFront) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                isFront ? 'Upload Front Side' : 'Upload Back Side',
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Drag & drop files here or browse your computer',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _pickImage(isFront),
                child: const Text(
                  'BROWSE FILES',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: ColorConstants.mainColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Display the selected image
        (isFront ? _frontImage : _backImage) != null
            ? Image.file(
          isFront ? _frontImage! : _backImage!,
          height: 200,
        )
            : Container(),
      ],
    );
  }
}
