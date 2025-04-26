class Organization {
  String? uid;
  String banner;
  String logo;
  String acronym;
  String name;
  String category;
  String email;
  String mobile;
  String facebook;
  bool status;

  Organization({
    required this.uid,
    required this.banner,
    required this.logo,
    required this.acronym,
    required this.name,
    required this.category,
    required this.email,
    required this.mobile,
    required this.facebook,
    required this.status,
  });

  factory Organization.fromMap(Map<String, dynamic> map) {
    print('Raw data from Supabase: $map'); // Debug print
    return Organization(
      uid: map['uid'] as String?,
      banner: map['banner'] as String,
      logo: map['logo'] as String,
      acronym: map['acronym'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      email: map['email'] as String,
      mobile: map['mobile'] as String,
      facebook: map['facebook'] as String,
      status: map['status'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'banner': banner,
      'logo': logo,
      'acronym': acronym,
      'name': name,
      'category': category,
      'email': email,
      'mobile': mobile,
      'facebook': facebook,
      'status': status,
    };
  }
}