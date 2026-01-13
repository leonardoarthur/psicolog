import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CatharsisScreen extends StatefulWidget {
  const CatharsisScreen({super.key});

  @override
  State<CatharsisScreen> createState() => _CatharsisScreenState();
}

class _CatharsisScreenState extends State<CatharsisScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLiberating = false;

  void _liberate() {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLiberating = true;
    });

    // Wait for animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _controller.clear();
        setState(() {
          _isLiberating = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pensamento liberado.')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catarse')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Escreva o que te aflige. Ao liberar, desaparecerá para sempre.',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Animate(
                target: _isLiberating ? 1 : 0,
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 600),
                    begin: 1,
                    end: 0,
                  ),
                  SlideEffect(
                    duration: Duration(milliseconds: 600),
                    begin: Offset.zero,
                    end: Offset(0, -0.5),
                  ),
                  BlurEffect(
                    duration: Duration(milliseconds: 600),
                    begin: Offset.zero,
                    end: Offset(10, 10),
                  ),
                ],
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Digite aqui...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _liberate,
              icon: const Icon(Icons.air),
              label: const Text('Liberar Pensamento'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
