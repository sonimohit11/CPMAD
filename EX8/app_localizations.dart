
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('gu', 'IN'),
    Locale('hi', 'IN'),
  ];

  static const Map<String, Map<String, String>> translations = {
    'en': {
      'title': 'Student Information',
      'welcome': 'Welcome to the Student App!',
      'language': 'Select Language',
      'english': 'English',
      'gujarati': 'Gujarati',
      'hindi': 'Hindi',
      'studentInfo': 'Student Details',
      'name': 'Name',
      'course': 'Course',
      'semester': 'Semester',
      'college': 'College',
      'date': 'Current Date',
      'number': 'Formatted Number',
      'eventPlanner': 'Event Planner',
      'upcomingEvent': 'Upcoming Event',
      'eventName': 'Flutter Lab Examination',
      'saved': 'Language preference saved!',
    },
    'gu': {
      'title': 'વિદ્યાર્થી માહિતી',
      'welcome': 'વિદ્યાર્થી એપમાં આપનું સ્વાગત છે!',
      'language': 'ભાષા પસંદ કરો',
      'english': 'અંગ્રેજી',
      'gujarati': 'ગુજરાતી',
      'hindi': 'હિન્દી',
      'studentInfo': 'વિદ્યાર્થીની વિગતો',
      'name': 'નામ',
      'course': 'અભ્યાસક્રમ',
      'semester': 'સેમેસ્ટર',
      'college': 'કોલેજ',
      'date': 'આજની તારીખ',
      'number': 'ફોર્મેટ કરેલી સંખ્યા',
      'eventPlanner': 'કાર્યક્રમ આયોજન',
      'upcomingEvent': 'આગામી કાર્યક્રમ',
      'eventName': 'ફ્લટર લેબ પરીક્ષા',
      'saved': 'ભાષાની પસંદગી સાચવાઈ ગઈ!',
    },
    'hi': {
      'title': 'विद्यार्थी जानकारी',
      'welcome': 'विद्यार्थी ऐप में आपका स्वागत है!',
      'language': 'भाषा चुनें',
      'english': 'अंग्रेज़ी',
      'gujarati': 'गुजराती',
      'hindi': 'हिंदी',
      'studentInfo': 'विद्यार्थी का विवरण',
      'name': 'नाम',
      'course': 'पाठ्यक्रम',
      'semester': 'सेमेस्टर',
      'college': 'कॉलेज',
      'date': 'आज की तारीख',
      'number': 'स्वरूपित संख्या',
      'eventPlanner': 'कार्यक्रम नियोजक',
      'upcomingEvent': 'आगामी कार्यक्रम',
      'eventName': 'फ्लटर लैब परीक्षा',
      'saved': 'भाषा की पसंद सहेज ली गई है!',
    },
  };

  String text(String key) {
    return translations[locale.languageCode]?[key] ??
        translations['en']![key] ??
        key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'gu', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
