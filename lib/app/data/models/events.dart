class Event {
  String? uid;
  String banner;
  String orguid;
  String title;
  String description;
  String location;
  String type;
  DateTime datetimestart; // Using DateTime for datetime fields
  DateTime datetimeend;   // Using DateTime for datetime fields
  String status;
  List<String> tags; // Using List<String> for string[]

  Event({
    required this.uid,
    required this.banner,
    required this.orguid,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.datetimestart,
    required this.datetimeend,
    required this.status,
    required this.tags,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    print('Raw data from Supabase: $map'); // Debug print
    return Event(
      uid: map['uid'] as String?,
      banner: map['banner'] as String,
      orguid: map['orguid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      location: map['location'] as String,
      type: map['type'] as String,
      datetimestart: DateTime.parse(map['datetimestart'] as String), // Parsing datetime
      datetimeend: DateTime.parse(map['datetimeend'] as String),     // Parsing datetime
      status: map['status'] as String,
      tags: List<String>.from(map['tags'] as List), // Converting list of strings
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'banner': banner,
      'orguid': orguid,
      'title': title,
      'description': description,
      'location': location,
      'type': type,
      'datetimestart': datetimestart.toIso8601String(), // Converting DateTime to ISO string
      'datetimeend': datetimeend.toIso8601String(),     // Converting DateTime to ISO string
      'status': status,
      'tags': tags, // Keeping tags as a list of strings
    };
  }
}