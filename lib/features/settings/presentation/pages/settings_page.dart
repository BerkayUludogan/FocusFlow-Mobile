import 'package:flutter/material.dart';

import '../mixins/settings_view_mixin.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SettingsViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: logout,
          child: const Text('Çıkış Yap'),
        ),
      ),
    );
  }
}
