class Student {
  final String id;
  final String name;
  final String email;
  final String rollNo;
  final String course;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNo,
    required this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'course': course,
    };
  }

  factory Student.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Student(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      rollNo: map['rollNo'] ?? '',
      course: map['course'] ?? '',
    );
  }
}