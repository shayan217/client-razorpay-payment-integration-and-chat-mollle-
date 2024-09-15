class Event {
  final int id;
  final String name;
  final String image;
  final String location;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String description;
  final double amount;
  final int seatLimit;
  final int? createdByUserId; // Make this field nullable

  Event({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.amount,
    required this.seatLimit,
    this.createdByUserId, // Initialize this as nullable
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      location: json['location'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      description: json['description'] ?? '',
      amount: double.parse(json['amount'] ?? '0.0'),
      seatLimit: json['seat_limit'] ?? 0,
      createdByUserId: json['created_by_user_id'] as int?, // Handle null value here
    );
  }
}
