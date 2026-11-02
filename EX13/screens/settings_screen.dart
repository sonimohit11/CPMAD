import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      children: [
        Card(child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
          title: Text(app.userEmail ?? 'Expense Manager user'),
          subtitle: Text(app.isCloudSession ? 'Firebase account • cloud sync on' : 'Local demo session'),
        )),
        const SizedBox(height: 12),
        Card(child: SwitchListTile(
          secondary: Icon(app.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
          title: const Text('Dark Mode'),
          subtitle: Text(app.isDarkMode ? 'Dark theme is active' : 'Light theme is active'),
          value: app.isDarkMode,
          onChanged: (val) => app.setDarkMode(val),
        )),
        const SizedBox(height: 12),
        Card(child: Column(children: [
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Test local notification'),
            subtitle: const Text('Show an expense reminder on supported devices'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await NotificationService.instance.showDailyReminder();
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder requested. On web, notifications are not enabled by this starter.')));
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: const Text('Schedule daily reminder'),
            subtitle: const Text('Repeat every day at 8:00 PM on Android'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final scheduled = await NotificationService.instance.scheduleDailyReminder();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(scheduled
                  ? 'Daily reminder scheduled for 8:00 PM.'
                  : 'Could not schedule reminder. Use an Android device and allow notifications.'),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_off_outlined),
            title: const Text('Cancel daily reminder'),
            onTap: () async {
              await NotificationService.instance.cancelDailyReminder();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Daily reminder cancelled.')),
              );
              }
            },
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Local persistence'),
            subtitle: Text('Transactions and budgets are saved on this device.'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text('Firebase cloud integration'),
            subtitle: Text(FirebaseService.instance.isReady
                ? 'Connected. Transactions and budgets sync to Firestore.'
                : 'Not configured. Run flutterfire configure to connect your project.'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              final yes = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
                title: const Text('Sign out?'),
                content: const Text('Your local transactions will remain on this device.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sign out')),
                ],
              ));
              if (yes == true && context.mounted) await context.read<AppProvider>().signOut();
            },
          ),
        ])),
        const SizedBox(height: 12),
        const Text('Note: Demo authentication is local only. Do not use it to protect sensitive financial data. Configure Firebase Authentication and Firestore for real user accounts and cloud storage.',
          style: TextStyle(color: Colors.black54, fontSize: 12)),
      ],
    );
  }
}
