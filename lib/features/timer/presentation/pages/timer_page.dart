import 'package:flutter/material.dart';

import '../mixins/timer_view_mixin.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TimerViewMixin {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Timer'));
  }
}
