import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String qualification = "Diploma";

  bool flutter = false;
  bool python = false;
  bool java = false;

  double experience = 0;

  bool remoteWork = false;

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(title: const Text("Job Application")),

        body: Form(
          key: formKey,

          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Enter Your Name",
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter Your Email",
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }

                    if (!value.contains("@")) {
                      return "Enter a valid email";
                    }

                    return null;
                  },
                ),

                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,

                  decoration: const InputDecoration(
                    labelText: "Enter Your Phone Number",
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number";
                    }

                    if (value.length != 10) {
                      return "Phone number must be 10 digits";
                    }

                    return null;
                  },
                ),

                const Text("Qualification"),

                RadioListTile(
                  title: const Text("Diploma"),
                  value: "Diploma",
                  groupValue: qualification,

                  onChanged: (value) {
                    setState(() {
                      qualification = value.toString();
                    });
                  },
                ),

                RadioListTile(
                  title: const Text("B.Tech"),
                  value: "B.Tech",
                  groupValue: qualification,

                  onChanged: (value) {
                    setState(() {
                      qualification = value.toString();
                    });
                  },
                ),

                const Text("Skills"),

                CheckboxListTile(
                  title: const Text("Flutter"),
                  value: flutter,

                  onChanged: (value) {
                    setState(() {
                      flutter = value!;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text("Python"),
                  value: python,

                  onChanged: (value) {
                    setState(() {
                      python = value!;
                    });
                  },
                ),

                CheckboxListTile(
                  title: const Text("Java"),
                  value: java,

                  onChanged: (value) {
                    setState(() {
                      java = value!;
                    });
                  },
                ),

                const Text("Experience"),

                Slider(
                  value: experience,
                  min: 0,
                  max: 10,
                  divisions: 10,

                  label: experience.round().toString(),

                  onChanged: (value) {
                    setState(() {
                      experience = value;
                    });
                  },
                ),

                Text("Experience: ${experience.round()} Years"),

                SwitchListTile(
                  title: const Text("Work From Home"),

                  value: remoteWork,

                  onChanged: (value) {
                    setState(() {
                      remoteWork = value;
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        submitted = true;
                      });
                    }
                  },

                  child: const Text("Apply"),
                ),

                if (submitted)
                  Column(
                    children: [
                      const Text(
                        "Application Submitted",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text("Name: ${nameController.text}"),

                      Text("Email: ${emailController.text}"),

                      Text("Phone: ${phoneController.text}"),

                      Text("Qualification: $qualification"),

                      Text("Experience: ${experience.round()} Years"),

                      Text(
                        "Skills: "
                        "${flutter ? "Flutter " : ""}"
                        "${python ? "Python " : ""}"
                        "${java ? "Java" : ""}",
                      ),

                      Text(
                        "Work From Home: "
                        "${remoteWork ? "Yes" : "No"}",
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }
}
