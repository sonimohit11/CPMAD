import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() =>
      _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _rollNo = TextEditingController();
  final _course = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    final s = widget.student;
    if (s != null) {
      _name.text = s.name;
      _email.text = s.email;
      _rollNo.text = s.rollNo;
      _course.text = s.course;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _rollNo.dispose();
    _course.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final student = Student(
        id: widget.student?.id ?? '',
        name: _name.text.trim(),
        email: _email.text.trim(),
        rollNo: _rollNo.text.trim(),
        course: _course.text.trim(),
      );

      if (widget.student == null) {
        await StudentService().addStudent(student);
      } else {
        await StudentService().updateStudent(student);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.student == null
                ? 'Student added successfully'
                : 'Student updated successfully',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save student: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
        validator: (value) =>
            value == null || value.trim().isEmpty
                ? 'Please enter $label'
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.student == null ? 'Add Student' : 'Edit Student',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _field(_name, 'Full Name'),
                  _field(
                    _email,
                    'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _field(_rollNo, 'Roll Number'),
                  _field(_course, 'Course'),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _save,
                      icon: const Icon(Icons.save),
                      label: Text(
                        _loading ? 'Saving...' : 'Save Student',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}