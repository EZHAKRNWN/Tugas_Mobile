import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<Duration> _laps = [];

  void _start() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      setState(() {});
    });
    setState(() {});
  }

  void _pause() {
    _stopwatch.stop();
    _timer?.cancel();
    setState(() {});
  }

  void _reset() {
    _stopwatch.reset();
    _timer?.cancel();
    _laps.clear();
    setState(() {});
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      setState(() => _laps.insert(0, _stopwatch.elapsed));
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final millis = twoDigits((d.inMilliseconds.remainder(1000) / 10).floor());
    return '$hours:$minutes:$seconds.$millis';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _stopwatch.isRunning;

    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Center(
            child: Text(
              _formatDuration(_stopwatch.elapsed),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: isRunning ? _addLap : _reset,
                icon: Icon(isRunning ? Icons.flag_outlined : Icons.refresh),
                label: Text(isRunning ? 'Lap' : 'Reset'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: isRunning ? _pause : _start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRunning ? AppColors.gold : AppColors.navy,
                  foregroundColor: isRunning ? AppColors.navy : Colors.white,
                ),
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(isRunning ? 'Jeda' : 'Mulai'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          Expanded(
            child: _laps.isEmpty
                ? const Center(
                    child: Text('Belum ada lap', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _laps.length,
                    itemBuilder: (context, index) {
                      final lapNumber = _laps.length - index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Lap $lapNumber', style: const TextStyle(color: Colors.grey)),
                            Text(
                              _formatDuration(_laps[index]),
                              style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}