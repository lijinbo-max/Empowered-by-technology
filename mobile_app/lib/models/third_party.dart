class LinkedInJob {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String postedAt;

  LinkedInJob({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.postedAt,
  });

  factory LinkedInJob.fromJson(Map<String, dynamic> json) {
    return LinkedInJob(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      description: json['description'] ?? '',
      postedAt: json['posted_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'posted_at': postedAt,
    };
  }
}

class IndeedJob {
  final String id;
  final String title;
  final String company;
  final String salary;
  final String location;
  final String description;
  final String url;

  IndeedJob({
    required this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.description,
    required this.url,
  });

  factory IndeedJob.fromJson(Map<String, dynamic> json) {
    return IndeedJob(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      salary: json['salary'] ?? '',
      location: json['location'],
      description: json['description'] ?? '',
      url: json['url'],
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
      'url': url,
    };
  }
}

class CareerAssessment {
  final int id;
  final String type;
  final String title;
  final List<Question> questions;

  CareerAssessment({
    required this.id,
    required this.type,
    required this.title,
    required this.questions,
  });

  factory CareerAssessment.fromJson(Map<String, dynamic> json) {
    return CareerAssessment(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      questions: (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final int id;
  final String text;
  final List<String> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
    };
  }
}

class SkillCertification {
  final int id;
  final String name;
  final String description;
  final String provider;
  final String level;

  SkillCertification({
    required this.id,
    required this.name,
    required this.description,
    required this.provider,
    required this.level,
  });

  factory SkillCertification.fromJson(Map<String, dynamic> json) {
    return SkillCertification(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      provider: json['provider'],
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'provider': provider,
      'level': level,
    };
  }
}

class OnlineCourse {
  final int id;
  final String title;
  final String description;
  final String provider;
  final String url;
  final double rating;
  final int duration;

  OnlineCourse({
    required this.id,
    required this.title,
    required this.description,
    required this.provider,
    required this.url,
    required this.rating,
    required this.duration,
  });

  factory OnlineCourse.fromJson(Map<String, dynamic> json) {
    return OnlineCourse(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      provider: json['provider'],
      url: json['url'],
      rating: json['rating'] ?? 0.0,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'provider': provider,
      'url': url,
      'rating': rating,
      'duration': duration,
    };
  }
}