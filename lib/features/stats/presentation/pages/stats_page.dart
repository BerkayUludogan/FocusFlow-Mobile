import 'package:flutter/material.dart';

import '../mixins/stats_view_mixin.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with StatsViewMixin {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Stats'));
  }
}
