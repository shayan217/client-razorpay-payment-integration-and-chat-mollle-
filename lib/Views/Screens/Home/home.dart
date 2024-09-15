import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart'; // Import the dropdown_search package
import 'package:molle/Views/Screens/Home/userprofile/users.dart';
import '../../../Controllers/api_servie_login.dart';
import '../../../Models/eventDto.dart';
import '../../../Models/userDto.dart';
import '../../../Utils/constants.dart';
import 'Profile/user_profile.dart';
import 'SingleEvent/single_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCity = ''; // Initially, no city is selected
  List<Event> events = []; // List to hold fetched events
  List<Event> _searchResults = []; // List to hold search results
  bool _isLoading = true;
  bool _isSearching = false; // Flag for search loading state
  User? _user;
  final AuthService _authService = AuthService();
  final TextEditingController _searchController =
      TextEditingController(); // Search controller
  List<String> cities = [
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Hyderabad",
    "Ahmedabad",
    "Chennai",
    "Kolkata",
    "Surat",
    "Pune",
    "Jaipur",
    "Lucknow",
    "Kanpur",
    "Nagpur",
    "Indore",
    "Thane",
    "Bhopal",
    "Visakhapatnam",
    "Pimpri-Chinchwad",
    "Patna",
    "Vadodara",
    "Ghaziabad",
    "Ludhiana",
    "Agra",
    "Nashik",
    "Faridabad",
    "Meerut",
    "Rajkot",
    "Kalyan-Dombivli",
    "Varanasi",
    "Srinagar",
    "Aurangabad",
    "Dhanbad",
    "Amritsar",
    "Navi Mumbai",
    "Allahabad",
    "Howrah",
    "Ranchi",
    "Coimbatore",
    "Jabalpur",
    "Gwalior",
    "Vijayawada",
    "Jodhpur",
    "Madurai",
    "Raipur",
    "Kota",
    "Guwahati",
    "Chandigarh",
    "Solapur",
    "Hubli-Dharwad",
    "Bareilly",
    "Tiruchirappalli",
    "Jalandhar",
    "Bhubaneswar",
    "Salem",
    "Warangal",
    "Thiruvananthapuram",
    "Guntur",
    "Bhiwandi",
    "Saharanpur",
    "Gorakhpur",
    "Bikaner",
    "Amravati",
    "Noida",
    "Jamshedpur",
    "Bhilai",
    "Cuttack",
    "Firozabad",
    "Kochi",
    "Nellore",
    "Bhavnagar",
    "Dehradun",
    "Durgapur",
    "Asansol",
    "Rourkela",
    "Nanded",
    "Kolhapur",
    "Ajmer",
    "Akola",
    "Gulbarga",
    "Jamnagar",
    "Ujjain",
    "Loni",
    "Siliguri",
    "Jhansi",
    "Ulhasnagar",
    "Jammu",
    "Sangli-Miraj & Kupwad",
    "Mangalore",
    "Erode",
    "Belgaum",
    "Ambattur",
    "Tirunelveli",
    "Malegaon",
    "Gaya",
    "Udaipur",
    "Maheshtala",
    "Dharwad",
    "Hapur",
    "Mysore",
    "Tiruppur",
    "Ghaziabad",
    "Aligarh",
    "Bhilwara",
    "Moradabad",
    "Bhatpara",
    "Tiruvottiyur",
    "Panihati",
    "Latur",
    "Sambalpur",
    "Shahjahanpur",
    "Bilaspur",
    "Muzaffarnagar",
    "Berhampur",
    "Mathura",
    "Thanjavur",
    "Faizabad",
    "Rajahmundry",
    "Bokaro Steel City",
    "South Dumdum",
    "Karimnagar",
    "Rampur",
    "Shimoga",
    "Tirupati",
    "Bilaspur",
    "Shimla",
    "Yamunanagar",
    "Muzaffarpur",
    "Ahmadnagar",
    "Nizamabad",
    "Thoothukudi",
    "Rohtak",
    "Korba",
    "Panipat",
    "Bhatinda",
    "Sonipat",
    "Darbhanga",
    "Bihar Sharif",
    "Bellary",
    "Katihar",
    "Satara",
    "Alwar",
    "Gopalpur",
    "Akbarpur",
    "Jalgaon",
    "Ballia",
    "Vellore",
    "Eluru",
    "Hisar",
    "Ambala",
    "Davanagere",
    "Mandsaur",
    "Chandrapur",
    "Unnao",
    "Munger",
    "Pali",
    "Haldia",
    "Nagercoil",
    "Sikar",
    "Bhagalpur",
    "Silchar",
    "Raiganj",
    "Ratlam",
    "Beed",
    "Haldwani",
    "Farrukhabad",
    "Amroha",
    "Raebareli",
    "Budaun",
    "Tumakuru",
    "Katni",
    "Mirzapur",
    "Raigarh",
    "Karimnagar",
    "Wardha",
    "Jind",
    "Jorhat",
    "Udhampur",
    "Imphal",
    "Kohima",
    "Kurnool",
    "Khammam",
    "Kollam",
    "Bhind",
    "Jhalawar",
    "Phusro",
    "Sirsa",
    "Saharsa",
    "Singrauli",
    "Balurghat",
    "Kolar",
    "Itarsi",
    "Junagadh",
    "Darjeeling",
    "Rishikesh",
    "Bharatpur",
    "Bhuj",
    "Karaikudi",
    "Chittoor",
    "Baramati",
    "Gangtok",
    "Pithampur",
    "Sawai Madhopur",
    "Barmer",
    "Navsari",
    "Mancherial",
    "Nandyal",
    "Jagdalpur",
    "Srikakulam",
    "Gadag-Betageri",
    "Nandurbar",
    "Fatehpur",
    "Rewa",
    "Chhapra",
    "Moga",
    "Hazaribagh",
    "Alappuzha",
    "Port Blair",
    "Begusarai",
    "Buxar",
    "Purnia",
    "Rampur",
    "Korba",
    "Jagadhri",
    "Orai",
    "Dewas",
    "Chandannagar",
    "Mandya",
    "Jaisalmer",
    "Betul",
    "Pathankot",
    "Rajsamand",
    "Bhadohi",
    "Malerkotla",
    "Vizianagaram",
    "Almora",
    "Gondia",
    "Sambalpur",
    "Kakinada",
    "Dindigul",
    "Miryalaguda",
    "Nagapattinam",
    "Shajapur",
    "Chhindwara",
    "Banswara",
    "Rewari",
    "Pithoragarh",
    "Mancherial",
    "Karnal",
    "Karauli",
    "Yavatmal",
    "Hoshangabad",
    "Jagatsinghapur",
    "Kaithal",
    "Mau",
    "Anantapur",
    "Bhavnagar",
    "Vapi",
    "Medinipur",
    "Rourkela",
    "Ghazipur",
    "Kumbakonam",
    "Dhule",
    "Nagaur",
    "Jalpaiguri",
    "Machilipatnam",
    "Sirhind",
    "Guna",
    "Sirohi",
    "Bhiwani",
    "Bhandara",
    "Baran",
    "Jajpur",
    "Churu",
    "Nagaon",
    "Faridkot",
    "Rajgarh",
    "Barabanki",
    "Fatehgarh Sahib",
    "Rajnandgaon",
    "Itanagar",
    "Fatehabad",
    "Gangapur",
    "Baripada",
    "Bijapur",
    "Sirsa",
    "Satna",
    "Mandla",
    "Sivasagar",
    "Goalpara",
    "Pathanamthitta",
    "Bardhaman",
    "Seoni",
    "Haridwar",
    "Jagdalpur",
    "Roorkee",
    "Gandhidham",
    "Adoni",
    "Dholpur",
    "Karur",
    "Karjat",
    "Dhamtari",
    "Ongole",
    "Ghatal",
    "Khanna",
    "Madhepura",
    "Dharmavaram",
    "Kanchipuram",
    "Naihati",
    "Chikkamagaluru",
    "Jhunjhunu",
    "Bahraich",
    "Kamareddy",
    "Rampurhat",
    "Balasore",
    "Dahod",
    "Morbi",
    "Angul",
    "Sivakasi",
    "Raichur",
    "Bhadrak",
    "Gadwal",
    "Bargarh",
    "Tezpur",
    "Samastipur",
    "Supaul",
    "Ambikapur",
    "Vizianagaram",
    "Kaimur",
    "Auraiya",
    "Gopalganj",
    "Balangir",
    "Ranaghat",
    "Nagaon",
    "Karaikudi",
    "Purnia",
    "Jhalawar",
    "Chamba",
    "Neemuch",
    "Jalore",
    "Nagda",
    "Sasaram",
    "Kalol",
    "Suratgarh",
    "Bhind",
    "Anuppur",
    "Hazaribagh",
    "Bharatpur",
    "Tinsukia",
    "Porbandar",
    "Mehsana",
    "Dausa",
    "Dhanbad",
    "Itarsi",
    "Guna",
    "Mandsaur",
    "Farrukhabad",
    "Kalimpong",
    "Goalpara",
    "Kasganj",
    "Firozabad",
    "Kadapa",
    "Chittorgarh",
    "Araria",
    "Raichur",
    "Lakhisarai",
    "Barnala",
    "Haridwar",
    "Gonda",
    "Bhatapara",
    "Korba",
    "Chhatarpur",
    "Godda",
    "Jaisalmer",
    "Mandi",
    "Narsinghpur",
    "Khagaria",
    "Munger",
    "Chittaurgarh",
    "Kheda",
    "Bhadohi",
    "Pauri",
    "Panchkula",
    "Sirsa",
    "Basti",
    "Shivpuri",
    "Junagadh",
    "Mainpuri",
    "Gangtok",
    "Mau",
    "Aizawl",
    "Bidar",
    "Rewa",
    "Sehore",
    "Giridih",
    "Haridwar",
    "Nawada",
    "Koraput",
    "Malda",
    "Mandla",
    "Tikamgarh",
    "Silvassa",
    "Parbhani",
    "Chamba",
    "Katihar",
    "Karauli",
    "Chapra",
    "Jagtial",
    "Dimapur",
    "Porbandar",
    "Pithoragarh",
    "Bargarh",
    "Karimganj",
    "Beed",
    "Sawai Madhopur",
    "Jalpaiguri",
    "Bundi",
    "Fatehpur",
    "Godda",
    "Jehanabad",
    "Betul",
    "Bhadrak",
    "Shajapur",
    "Banda",
    "Ratnagiri",
    "Banswara",
    "Bahadurgarh",
    "Sonitpur",
    "Ferozepur",
    "Jalor",
    "Karauli",
    "Shivpuri",
    "Khandwa",
    "Goalpara",
    "Thoubal",
    "Chandrapur",
    "Gandhidham",
    "Mathura",
    "Khandwa",
    "Hingoli",
    "Pauri Garhwal",
    "Garhwa",
    "Amroha",
    "Virudhunagar",
    "Siwan",
    "Vaishali",
    "Budaun",
    "Purnia",
    "Baran",
    "Jhabua",
    "Kushinagar",
    "Ambikapur",
    "Kokrajhar",
    "Bokaro",
    "Hoshangabad",
    "Vidisha",
    "Kullu",
    "Rajgarh",
    "Palwal",
    "Kendujhar",
    "Bilaspur",
    "Narsinghpur",
    "Bhind",
    "Sagar",
    "Jhajjar",
    "Katni",
    "Jamtara",
    "Champawat",
    "Raigarh",
    "Satara",
    "Kendrapara",
    "Jhajjar",
    "Betul",
    "Kaimur",
    "Mandsaur",
    "Kanker",
    "Jagdalpur",
    "Balaghat",
    "Narnaul",
    "Balangir",
    "Kasaragod",
    "Navsari",
    "Palghar",
    "Gandhinagar",
    "Harda",
    "Firozpur",
    "Bastar",
    "Barwani",
    "Bagalkot",
    "Yadgir",
    "Dhar",
    "Chikkaballapur",
    "Chitradurga",
    "Jagatsinghapur",
    "Balangir",
    "Karauli",
    "Tuensang",
    "Bhadohi",
    "Khagaria",
    "Chandel",
    "Wayanad",
    "Kangra",
    "Sawai Madhopur",
    "Khunti",
    "Sahibganj",
    "Barpeta",
    "Bongaigaon",
    "Patiala",
    "Bilaspur",
    "Dhemaji",
    "Cachar",
    "Jaintia Hills",
    "Jorhat",
    "Kamrup",
    "Koppal",
    "Nagaur",
    "Karbi Anglong",
    "Lakhimpur",
    "Lunglei",
    "Phek",
    "Kiphire",
    "Senapati",
    "Tamenglong",
    "Thoubal",
    "Bishnupur",
    "Gopalganj",
    "Uttarkashi",
    "Srinagar",
    "Sant Ravidas Nagar",
    "Nagaon",
    "Karimganj",
    "Saiha",
    "Mamit",
    "Tuensang",
    "Champhai",
    "Khowai",
    "West Khasi Hills",
    "Ri Bhoi",
    "West Garo Hills",
    "North Garo Hills",
    "South Garo Hills",
    "East Garo Hills",
    "West Jaintia Hills",
    "West Siang",
    "Upper Siang",
    "Lohit",
    "Upper Subansiri",
    "Lower Subansiri",
    "Papum Pare",
    "Kurung Kumey",
    "East Kameng",
    "Tawang",
    "Changlang",
    "Anjaw",
    "Longding",
    "Lower Dibang Valley",
    "Namsai",
    "Siang",
    "Lower Siang",
    "East Siang",
    "Kamle",
    "Kra Daadi",
    "Upper Dibang Valley",
    "Dibang Valley"
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _fetchEvents(); // Fetch events when initializing
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.getProfile();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load user data. Please try again.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedEvents =
          await _authService.fetchEvents(1); // Fetch events for page 1
      setState(() {
        events = fetchedEvents.take(4).toList(); // Take up to 4 events
        newChipFilterList = events; // Show all events

        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch events: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to fetch events. Please try again.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to fetch events by city
  Future<void> _fetchEventsByCity(String city) async {
    setState(() {
      _isLoading = true;
      events.clear(); // Clear current events
    });

    try {
      final fetchedEvents = await _authService.fetchEventsByCity(city);
      setState(() {
        if (fetchedEvents.isEmpty) {
          // No events found for the selected city
          events = [];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No events found in $city.')),
          );
        } else {
          // Events found for the selected city
          events = fetchedEvents;
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch events for city: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch events for $city.')),
      );
      setState(() {
        _isLoading = false;
      });
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

  List<String> listItem = [
    'Concerts',
    'House-parties',
    'Festival',
    'Theme party',
    'Birthday party',
    'Rave',
    'Pool party',
    'Much More!',
  ];
  int _selectedChipIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: ColorConstants.mainColor,
        elevation: 0,
        title: const Center(
          child: Image(
            image: AssetImage("assets/AppLogo.png"),
            height: 110,
            width: 110,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi ${_user?.fullname ?? 'User'}!',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover Amazing Events',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  // Dropdown for City Selection with Search
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 25,
                          color: Colors.purpleAccent,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.bottomSheet(
                              showSearchBox: true, // Enable the search box
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: 'Search for a city',
                                  // Placeholder text for the search box
                                  contentPadding: const EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              title: Container(
                                height: 50,
                                decoration: const BoxDecoration(
                                  // color: Colors.purpleAccent,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Select your city',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                            items: cities,
                            // Provide the list of cities
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select your city",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null &&
                                  newValue != 'Select a city') {
                                setState(() {
                                  selectedCity = newValue;
                                  _fetchEventsByCity(
                                      selectedCity); // Fetch events for the selected city
                                });
                              }
                            },
                            selectedItem: selectedCity.isEmpty
                                ? "Select a city"
                                : selectedCity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listItem.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            ChoiceChip(
                              onSelected: (val) {
                                setState(() {
                                  _selectedChipIndex = val ? index : -1;
                                });
                                _filterEventsByCategory(listItem[index]);
                                // _buildEventsList();
                              },
                              elevation: 3,
                              label: Text(listItem[index]),
                              backgroundColor: Colors.grey[200],
                              selected: _selectedChipIndex == index,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(width: 10),
                    ),
                  ),
                  // _buildCategoryChip(listItem[index],
                  //                           isSelected: isChoose, onSelected: (val) {});
                  const SizedBox(height: 10),
                  Expanded(
                    child: _isSearching
                        ? const Center(child: CircularProgressIndicator())
                        : _searchResults.isNotEmpty
                            ? _buildSearchResultsList()
                            : _buildEventsList(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget _customDropDown(
      BuildContext context, String? item, String? selectedItem) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        item ?? '',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    if (newChipFilterList.isEmpty) {
      log('message');
      return const Center(child: Text('No events available.'));
    }
    log(newChipFilterList.length.toString());
    return ListView.builder(
      itemCount: newChipFilterList.length,
      itemBuilder: (context, index) {
        final event = newChipFilterList[index];
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
          context,
        );
      },
    );
  }

  List<Event> newChipFilterList = [];
  void _filterEventsByCategory(String category) {
    log('list ${events.length}');
    // newChipFilterList.clear();
    setState(() {
      // Filter _allEvents based on the selected category
      if (category == 'Much More!') {
        log('herer in all category');
        newChipFilterList = List.from(events); // Show all events
      } else {
        //log('event ${events.first.name}');
        newChipFilterList = events
            .where((event) => event.name == category)
            .toList(); // Filter by category
        log('$newChipFilterList');
      }
    });
  }

  Widget _buildSearchResultsList() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final event = _searchResults[index];
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
          context,
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
    int? createdByUserId,
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
                                User host =
                                    await _fetchHostDetails(createdByUserId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfile(user: host),
                                  ),
                                );
                              }
                            : null,
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

  Widget _buildCategoryChip(String label,
      {required bool isSelected, required void Function(bool) onSelected}) {
    return ChoiceChip(
      onSelected: onSelected,
      elevation: 3,
      label: Text(label),
      backgroundColor: Colors.grey[200],
      selected: isSelected,
    );
  }
}
