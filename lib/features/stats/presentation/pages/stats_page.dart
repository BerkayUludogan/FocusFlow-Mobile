import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

import '../mixins/stats_view_mixin.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with StatsViewMixin {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(LocaleKeys.shellStats.tr()));
  }
}
