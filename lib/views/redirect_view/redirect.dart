import 'package:finetravel/services/auth.dart';
import 'package:finetravel/services/social_service.dart';
import 'package:finetravel/views/social_view/social_overview_page.dart';
import 'package:flutter/material.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Auth().currentUser;
    final socialService = SocialService();
    final String displayName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Explorer';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Profile Header
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${user?.uid}'),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? '',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: 30),
            // Social Stats
            ListenableBuilder(
              listenable: socialService,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem('Friends', socialService.friends.length.toString()),
                    _statItem('Trips', '12'), // Mocked
                    _statItem('Photos', '45'), // Mocked
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            // Actions
            _profileAction(
              context,
              icon: Icons.people_outline,
              title: 'Social & Friends',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SocialOverviewPage()),
              ),
            ),
            _profileAction(context, icon: Icons.history, title: 'Travel History', onTap: () {}),
            _profileAction(context, icon: Icons.payment, title: 'Payment Methods', onTap: () {}),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () async {
                    await Auth().signOut();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _profileAction(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
