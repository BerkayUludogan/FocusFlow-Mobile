import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

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
      appBar: AppBar(title: Text(LocaleKeys.shellSettings.tr())),
      body: Center(
        child: ElevatedButton(
          onPressed: logout,
          child: Text(LocaleKeys.settingsLogout.tr()),
        ),
      ),
    );
  }
}
