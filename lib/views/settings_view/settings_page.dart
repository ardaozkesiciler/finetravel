import 'package:finetravel/services/auth.dart';
import 'package:finetravel/services/theme_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingSection('Account', [
            _settingItem(Icons.person_outline, 'Edit Profile'),
            _settingItem(Icons.lock_outline, 'Privacy & Security'),
            _settingItem(Icons.notifications_none, 'Notifications Settings'),
          ]),
          const SizedBox(height: 30),
          _settingSection('Appearance', [
            ListenableBuilder(
              listenable: ThemeService(),
              builder: (context, _) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, size: 22),
                  title: const Text('Dark Mode'),
                  value: ThemeService().themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    ThemeService().toggleTheme(value);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ]),
          const SizedBox(height: 30),
          _settingSection('App Information', [
            _settingItem(Icons.info_outline, 'About Fine Travel', onTap: () => _showAboutDialog(context)),
            _settingItem(Icons.description_outlined, 'Terms of Service'),
            _settingItem(Icons.privacy_tip_outlined, 'Privacy Policy'),
            const ListTile(
              title: Text('App Version'),
              trailing: Text('1.0.0'),
            ),
          ]),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                await Auth().signOut();
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.flight_takeoff, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            const Text('About Fine Travel', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keşfet, Paylaş, Seyahat Et!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 12),
            Text(
              'Fine Travel, yeni yerler keşfetmeyi seven gezginler için tasarlanmış yeni nesil bir sosyal seyahat uygulamasıdır.\n\n'
              'Amacımız, dünyadaki ve çevrenizdeki en güzel mekanları kaydırarak (swipe) interaktif ve eğlenceli bir şekilde keşfetmenizi, kendi seyahat rotalarınızı oluşturmanızı ve arkadaşlarınızla anında paylaşabilmenizi sağlamaktır.\n\n'
              'Topluluğa kendi bulduğunuz gizli cennetleri ekleyebilir, diğer insanların deneyimlerinden ilham alabilir ve bir sonraki maceranızı Fine Travel ile planlayabilirsiniz.',
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Made with ❤️ for travelers',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white.withValues(alpha: 0.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _settingSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _settingItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
