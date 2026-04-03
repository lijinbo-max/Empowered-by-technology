class User {
  final int id;
  final String email;
  final String name;
  final String gender;
  final int age;
  final String phone;
  final String education;
  final String major;
  final String school;
  final int workExperience;
  final String position;
  final String company;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.age,
    required this.phone,
    required this.education,
    required this.major,
    required this.school,
    required this.workExperience,
    required this.position,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      phone: json['phone'] ?? '',
      education: json['education'] ?? '',
      major: json['major'] ?? '',
      school: json['school'] ?? '',
      workExperience: json['work_experience'] ?? 0,
      position: json['position'] ?? '',
      company: json['company'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'gender': gender,
      'age': age,
      'phone': phone,
      'education': education,
      'major': major,
      'school': school,
      'work_experience': workExperience,
      'position': position,
      'company': company,
    };
  }
}