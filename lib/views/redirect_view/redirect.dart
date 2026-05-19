import 'dart:io';
import 'package:finetravel/services/auth.dart';
import 'package:finetravel/services/social_service.dart';
import 'package:finetravel/views/social_view/social_overview_page.dart';
import 'package:finetravel/views/redirect_view/travel_history_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Redirect extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Auth(),
      builder: (context, child) {
        final user = Auth().currentUser;
        final socialService = SocialService();
        final String displayName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Explorer';

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Profile Header
                GestureDetector(
                  onTap: () => _pickAndCropImage(context),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: Auth().avatarPath != null 
                            ? FileImage(File(Auth().avatarPath!)) as ImageProvider
                            : NetworkImage('https://i.pravatar.cc/150?u=${user?.uid}'),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '@${Auth().username}',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                ),
                Text(
                  user?.email ?? '',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
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
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () => _showEditProfileDialog(context),
                ),
                _profileAction(
                  context,
                  icon: Icons.people_outline,
                  title: 'Social & Friends',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SocialOverviewPage()),
                  ),
                ),
                _profileAction(
                  context,
                  icon: Icons.history,
                  title: 'Travel History',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TravelHistoryPage()),
                  ),
                ),
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
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _EditProfileDialog(),
    );
  }

  Future<void> _pickAndCropImage(BuildContext context) async {
    final picker = ImagePicker();
    
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: Theme.of(context).colorScheme.surface,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        await Auth().updateAvatar(croppedFile.path);
      }
    }
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

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog();

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  String? usernameError;
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    final user = Auth().currentUser;
    nameController = TextEditingController(text: user?.displayName);
    usernameController = TextEditingController(text: Auth().username);
    usernameController.addListener(_validateUsername);
  }

  void _validateUsername() {
    final auth = Auth();
    final value = usernameController.text;
    if (value.isEmpty) {
      setState(() {
        usernameError = 'Username cannot be empty';
        suggestions = [];
      });
      return;
    }

    if (!auth.isUsernameAvailable(value)) {
      setState(() {
        usernameError = 'This username is already taken';
        suggestions = auth.suggestUsernames(value);
      });
    } else {
      setState(() {
        usernameError = null;
        suggestions = [];
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
                prefixText: '@',
                errorText: usernameError,
              ),
            ),
            if (suggestions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Suggested:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: suggestions.map((s) => ActionChip(
                  label: Text('@$s', style: const TextStyle(fontSize: 11)),
                  onPressed: () {
                    usernameController.text = s;
                  },
                )).toList(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: usernameError == null ? () async {
            if (nameController.text.isNotEmpty && usernameController.text.isNotEmpty) {
              await Auth().updateDisplayName(nameController.text);
              await Auth().updateUsername(usernameController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!')),
              );
            }
          } : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
