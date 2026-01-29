import 'package:flutter/material.dart';

class BlockConfigScreen extends StatelessWidget {
  const BlockConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar bloqueo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selecciona la duración',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _DurationButton(
              label: '15 minutos',
              onTap: () => _onDurationSelected(context, 15),
            ),
            _DurationButton(
              label: '30 minutos',
              onTap: () => _onDurationSelected(context, 30),
            ),
            _DurationButton(
              label: '1 hora',
              onTap: () => _onDurationSelected(context, 60),
            ),
          ],
        ),
      ),
    );
  }

  void _onDurationSelected(BuildContext context, int minutes) {
    debugPrint('Duración seleccionada: $minutes minutos');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bloqueo configurado por $minutes minutos'),
      ),
    );
  }
}

class _DurationButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DurationButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: Text(label),
      ),
    );
  }
}
