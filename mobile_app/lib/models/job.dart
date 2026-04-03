class Job {
  final int id;
  final String title;
  final String company;
  final String salary;
  final String location;
  final String description;
  final String requirements;
  final String responsibilities;
  final String postedAt;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.description,
    required this.requirements,
    required this.responsibilities,
    required this.postedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      salary: json['salary'],
      location: json['location'],
      description: json['description'] ?? '',
      requirements: json['requirements'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
      postedAt: json['posted_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'salary': salary,
      'location': location,
      'description': description,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'posted_at': postedAt,
    };
  }
}