import 'package:flutter/material.dart';

class DeveloperProfile extends StatelessWidget {
  const DeveloperProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Resume"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Profile Image
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                  width: 160,
                  height: 160,
                ),
              ),

              // Name
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: const Text(
                  "Mohit Parekh",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Qualification
              const Text(
                "B.Tech - ICT",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              // Education
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Education",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "B.Tech - Information and Communication Technology",
                        style: TextStyle(fontSize: 18),
                      ),

                      Text(
                        "Diploma in ICT",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // Experience
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Experience",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Data Science & Analytics Intern",
                        style: TextStyle(fontSize: 18),
                      ),

                      Text(
                        "Worked on business sales analysis and dashboards.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // Projects
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Projects",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "• Smart Timetable Display",
                        style: TextStyle(fontSize: 18),
                      ),

                      Text(
                        "• Store Management System",
                        style: TextStyle(fontSize: 18),
                      ),

                      Text(
                        "• Developer Portfolio App",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              // Skills
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [

                      const Text(
                        "Skills",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: const [
                          Expanded(
                            child: Center(
                              child: Text(
                                "Flutter",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "Dart",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "C++",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Center(
                              child: Text(
                                "Python",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Achievements
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Achievements",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "• Completed Data Science & Analytics Internship",
                        style: TextStyle(fontSize: 17),
                      ),

                      Text(
                        "• Developed multiple academic projects",
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ),

              // Contact
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: const [

                      Text(
                        "Contact",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),

                          SizedBox(width: 10),

                          Flexible(
                            child: Text(
                              "mohit11@gmail.com",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),

                          SizedBox(width: 10),

                          Flexible(
                            child: Text(
                              "+91 98765 43210",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}