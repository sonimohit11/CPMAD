
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'app_localizations.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await initializeDateFormatting();

//   final prefs = await SharedPreferences.getInstance();
//   final savedLanguage = prefs.getString('languageCode') ?? 'en';

//   runApp(
//     StudentInfoApp(
//       initialLocale: getLocale(savedLanguage),
//     ),
//   );
// }

// Locale getLocale(String languageCode) {
//   switch (languageCode) {
//     case 'gu':
//       return const Locale('gu', 'IN');
//     case 'hi':
//       return const Locale('hi', 'IN');
//     default:
//       return const Locale('en', 'US');
//   }
// }

// class StudentInfoApp extends StatefulWidget {
//   final Locale initialLocale;

//   const StudentInfoApp({
//     super.key,
//     required this.initialLocale,
//   });

//   @override
//   State<StudentInfoApp> createState() => _StudentInfoAppState();
// }

// class _StudentInfoAppState extends State<StudentInfoApp> {
//   late Locale currentLocale;

//   @override
//   void initState() {
//     super.initState();
//     currentLocale = widget.initialLocale;
//   }

//   Future<void> changeLanguage(String code) async {
//     final newLocale = getLocale(code);

//     setState(() {
//       currentLocale = newLocale;
//     });

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('languageCode', code);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Student Information App',
//       locale: currentLocale,
//       supportedLocales: AppLocalizations.supportedLocales,
//       localizationsDelegates: const [
//         AppLocalizationsDelegate(),
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.indigo,
//         ),
//         useMaterial3: true,
//       ),
//       home: StudentHomePage(
//         currentLocale: currentLocale,
//         onLanguageChanged: changeLanguage,
//       ),
//     );
//   }
// }

// class StudentHomePage extends StatelessWidget {
//   final Locale currentLocale;
//   final Future<void> Function(String) onLanguageChanged;

//   const StudentHomePage({
//     super.key,
//     required this.currentLocale,
//     required this.onLanguageChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final app = AppLocalizations.of(context);

//     final localeCode = currentLocale.toString();

//     final today = DateTime.now();
//     final eventDate = DateTime(2026, 11, 15);

//     final formattedDate =
//         DateFormat.yMMMMd(localeCode).format(today);

//     final formattedEventDate =
//         DateFormat.yMMMMd(localeCode).format(eventDate);

//     final formattedNumber =
//         NumberFormat.decimalPattern(localeCode).format(1234567.89);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(app.text('title')),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Icon(
//             Icons.school,
//             size: 65,
//             color: Colors.indigo,
//           ),
//           const SizedBox(height: 10),

//           Center(
//             child: Text(
//               app.text('welcome'),
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Language selection
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     app.text('language'),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   DropdownButtonFormField<String>(
//                     key: ValueKey(currentLocale.languageCode),
//                     initialValue: currentLocale.languageCode,
//                     isExpanded: true,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.language),
//                     ),
//                     items: [
//                       DropdownMenuItem(
//                         value: 'en',
//                         child: Text(app.text('english')),
//                       ),
//                       DropdownMenuItem(
//                         value: 'gu',
//                         child: Text(app.text('gujarati')),
//                       ),
//                       DropdownMenuItem(
//                         value: 'hi',
//                         child: Text(app.text('hindi')),
//                       ),
//                     ],
//                     onChanged: (value) async {
//                       if (value == null) return;

//                       await onLanguageChanged(value);

//                       if (!context.mounted) return;

//                       final updatedApp = AppLocalizations.of(context);

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(updatedApp.text('saved')),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // Student information
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     app.text('studentInfo'),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Divider(),
//                   infoRow(app.text('name'), 'Rahul Patel'),
//                   infoRow(app.text('course'), 'B.Tech ICT'),
//                   infoRow(app.text('semester'), '4'),
//                   infoRow(app.text('college'), 'ABC College'),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // Date and number formatting
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     app.text('date'),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     formattedDate,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const Divider(height: 28),
//                   Text(
//                     app.text('number'),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     formattedNumber,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // Event planner
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     app.text('eventPlanner'),
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: const Icon(
//                       Icons.event,
//                       color: Colors.indigo,
//                     ),
//                     title: Text(app.text('upcomingEvent')),
//                     subtitle: Text(app.text('eventName')),
//                   ),
//                   Text(
//                     formattedEventDate,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget infoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 3,
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'calculator_screen.dart';
import 'app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final prefs = await SharedPreferences.getInstance();
  final savedLanguage = prefs.getString('languageCode') ?? 'en';

  runApp(
    StudentInfoApp(
      initialLocale: getLocale(savedLanguage),
    ),
  );
}

Locale getLocale(String code) {
  switch (code) {
    case 'gu':
      return const Locale('gu', 'IN');
    case 'hi':
      return const Locale('hi', 'IN');
    default:
      return const Locale('en', 'US');
  }
}

class StudentInfoApp extends StatefulWidget {
  final Locale initialLocale;

  const StudentInfoApp({
    super.key,
    required this.initialLocale,
  });

  @override
  State<StudentInfoApp> createState() => _StudentInfoAppState();
}

class _StudentInfoAppState extends State<StudentInfoApp> {
  late Locale locale;

  @override
  void initState() {
    super.initState();
    locale = widget.initialLocale;
  }

  Future<void> changeLanguage(String code) async {
    final newLocale = getLocale(code);

    setState(() {
      locale = newLocale;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(
        locale: locale,
        onLanguageChanged: changeLanguage,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Locale locale;
  final Future<void> Function(String) onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.locale,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(app.text('title'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.school, size: 70, color: Colors.indigo),
          const SizedBox(height: 12),
          Center(
            child: Text(
              app.text('welcome'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Post-Lab Task 1
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(app.text('language')),
              subtitle: Text(app.text('changeLanguage')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LanguagePreferenceScreen(
                      locale: locale,
                      onLanguageChanged: onLanguageChanged,
                    ),
                  ),
                );
              },
            ),
          ),

          // Post-Lab Task 2
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(app.text('eventPlanner')),
              subtitle: Text(app.text('upcomingEvent')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventPlannerScreen(locale: locale),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.text('studentInfo'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  infoRow(app.text('name'), 'Rahul Patel'),
                  infoRow(app.text('course'), 'B.Tech ICT'),
                  infoRow(app.text('semester'), '4'),
                  infoRow(app.text('college'), 'ABC College'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}

// POST-LAB TASK 1: Language Preference with Persistence

class LanguagePreferenceScreen extends StatelessWidget {
  final Locale locale;
  final Future<void> Function(String) onLanguageChanged;

  const LanguagePreferenceScreen({
    super.key,
    required this.locale,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(app.text('language'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.translate, size: 60, color: Colors.indigo),
            const SizedBox(height: 20),
            Text(
              app.text('language'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            languageButton(context, 'en', app.text('english')),
            languageButton(context, 'gu', app.text('gujarati')),
            languageButton(context, 'hi', app.text('hindi')),
            const SizedBox(height: 16),
            Text(
              '${app.text('language')}: ${locale.languageCode.toUpperCase()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget languageButton(
    BuildContext context,
    String code,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () async {
            await onLanguageChanged(code);
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).text('saved'),
                ),
              ),
            );
          },
          child: Text(label),
        ),
      ),
    );
  }
}

// POST-LAB TASK 2: Locale-Aware Event Planner

class EventPlannerScreen extends StatelessWidget {
  final Locale locale;

  const EventPlannerScreen({
    super.key,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context);

    final events = [
      DateTime(2026, 11, 15),
      DateTime(2026, 12, 5),
      DateTime(2027, 1, 10),
    ];

    final names = [
      app.text('eventName'),
      app.text('upcomingEvent'),
      app.text('studentInfo'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(app.text('eventPlanner'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final date = DateFormat.yMMMMd(
            locale.toString(),
          ).format(events[index]);

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.calendar_month,
                color: Colors.indigo,
              ),
              title: Text(names[index]),
              subtitle: Text(date),
            ),
          );
        },
      ),
    );
  }
}
