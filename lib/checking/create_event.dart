import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:molle/Controllers/api_servie_login.dart';
import 'package:molle/Utils/constants.dart';
import '../../../../Models/userDto.dart';
import '../Views/Screens/Home/Card_verify/card_verify.dart';
import 'adhar_card.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final AuthService _authService = AuthService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hostedByController = TextEditingController();
  final TextEditingController _amountController =
  TextEditingController(text: '299'); // Minimum amount set to 299 INR
  final TextEditingController _seatLimitMenController =
  TextEditingController(text: '50');
  final TextEditingController _seatLimitWomenController =
  TextEditingController(text: '50');
  final List<Map<String, String>> _eventTypes = [
    {'1': 'House-parties'},
    {'2': 'Concerts'},
    {'3': 'Festival'},
    {'4': 'Theme party'},
    {'5': 'Rave'},
    {'6': 'Birthday party'},
    {'7': 'Pool party'},
    {'8': 'Beach party'},
    {'9': 'Film & Theater'},
    {'10': 'Car meetup'},
    {'11': 'Clubs'},
    {'12': 'Gaming'},
    {'13': 'Travel'},
    {'14': 'Networking'},
    {'15': 'Food & Drinks'},
    {'16': 'Fashion'},
    {'17': 'Arts'},
    {'18': 'Health & Wellness'},
    {'19': 'Pets & Animals'},
  ];
  String? _selectedEventType;
  File? _image;
  int _ageLimit = 18;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text =
        "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString()
          .padLeft(2, '0')}:00";
      setState(() {
        controller.text = formattedTime; // Ensure the format is HH:mm:ss
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    // Validate required fields
    if (_titleController.text.isEmpty ||
        _selectedEventType == null ||
        _descriptionController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _endTimeController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _hostedByController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _seatLimitMenController.text.isEmpty ||
        _seatLimitWomenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    // Validate amount
    if (double.tryParse(_amountController.text) == null ||
        double.parse(_amountController.text) < 299) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry fee must be at least 299 INR.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User userProfile = await _authService.getProfile();

      if (userProfile.isVerified) {
        int seatLimitMen = int.parse(_seatLimitMenController.text);
        int seatLimitWomen = int.parse(_seatLimitWomenController.text);
        int totalSeatLimit = seatLimitMen + seatLimitWomen;

        await _authService.createEvent(
          name: _titleController.text,
          eventTypeId: _selectedEventType!,
          location: _locationController.text,
          startTime: _startTimeController.text,
          endTime: _endTimeController.text,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
          description: _descriptionController.text,
          paid: true,
          amount: double.parse(_amountController.text),
          seatLimit: totalSeatLimit,
          ageLimit: _ageLimit,
          image: _image,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
              Text('Verification needed. Please verify your account.')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DocumentUploadScreen()), // Navigate to the document upload screen
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _startDateController.clear();
    _startTimeController.clear();
    _endDateController.clear();
    _endTimeController.clear();
    _locationController.clear();
    _hostedByController.clear();
    _selectedEventType = null;
    _image = null;
    _seatLimitMenController.text = '50';
    _seatLimitWomenController.text = '50';
    _amountController.text = '299';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.mainColor,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Host An Event',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: _image != null
                          ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _image == null
                        ? Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey[800],
                      ),
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField('Event Title', 'Enter event title',
                  controller: _titleController),
              const SizedBox(height: 16),
              _buildDropdownField(
                  'Event Type', 'Select event type', _eventTypes),
              const SizedBox(height: 16),
              _buildTextField(
                  'Event Description', 'Write your event description',
                  controller: _descriptionController, maxLines: 3),
              const SizedBox(height: 16),
              const Text('Event Timing',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, _startDateController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                            'Start Date', 'Select start date',
                            controller: _startDateController,
                            icon: Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, _startTimeController),
                      child: AbsorbPointer(
                        child: _buildTextField(
                            'Start Time', 'Select start time',
                            controller: _startTimeController,
                            icon: Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, _endDateController),
                      child: AbsorbPointer(
                        child: _buildTextField('End Date', 'Select end date',
                            controller: _endDateController,
                            icon: Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context, _endTimeController),
                      child: AbsorbPointer(
                        child: _buildTextField('End Time', 'Select end time',
                            controller: _endTimeController,
                            icon: Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Location', 'Enter location',
                  controller: _locationController, icon: Icons.location_on),
              const SizedBox(height: 16),
              _buildTextField('Hosted By', 'Enter host name',
                  controller: _hostedByController),
              const SizedBox(height: 16),
              _buildTextField(
                  'Entry Fee (INR)', 'Enter entry fee for event (min 299 INR)',
                  controller: _amountController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        'Seat Limit for Men', 'Enter seat limit for men',
                        controller: _seatLimitMenController,
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                        'Seat Limit for Women', 'Enter seat limit for women',
                        controller: _seatLimitWomenController,
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Document(),));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.mainColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Next',
                      style:
                      TextStyle(fontSize: 15, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {int maxLines = 1,
        IconData? icon,
        TextEditingController? controller,
        TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        if (label.isNotEmpty) const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint,
      List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items.map((item) {
            String key = item.keys.first;
            String value = item[key]!;
            return DropdownMenuItem<String>(
              value: key,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEventType = value;
            });
          },
        ),
      ],
    );
  }
}
