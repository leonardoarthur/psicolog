import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';

class EntryFormWidget extends StatefulWidget {
  final EntryType type;
  final ScrollController scrollController;

  const EntryFormWidget({
    super.key,
    required this.type,
    required this.scrollController,
  });

  @override
  State<EntryFormWidget> createState() => _EntryFormWidgetState();
}

class _EntryFormWidgetState extends State<EntryFormWidget> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _associationsController = TextEditingController();

  String? _selectedWakeUpMood;
  final List<String> _selectedTags = [];
  double _intensity = 3.0;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _associationsController.dispose();
    super.dispose();
  }

  void _save() {
    // If dream, content can be empty if title is present? Or vice versa.
    // Plan: Title optional. Content required? Maybe allow empty description if tags present?
    // Let's enforce some content or title.
    if (_contentController.text.isEmpty && _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva algo para salvar.')),
      );
      return;
    }

    final entry = Entry()
      ..type = widget.type
      ..title = _titleController.text.isNotEmpty ? _titleController.text : null
      ..content = _contentController.text
      ..timestamp = DateTime.now();

    if (widget.type == EntryType.dream) {
      entry.wakeUpMood = _selectedWakeUpMood;
      entry.dreamTags = _selectedTags;
      entry.dreamAssociations = _associationsController.text.isNotEmpty
          ? _associationsController.text
          : null;
    } else if (widget.type == EntryType.emotion) {
      entry.dailyMood = _intensity.round();
    }

    context.read<JournalProvider>().addEntry(entry);
    Navigator.pop(context);
  }

  String get _titleLabel {
    switch (widget.type) {
      case EntryType.dream:
        return 'Nome do Sonho (Opcional)';
      case EntryType.insight:
        return 'Título do Insight';
      case EntryType.emotion:
        return 'Humor';
    }
  }

  String get _contentLabel {
    switch (widget.type) {
      case EntryType.dream:
        return 'Relato do sonho...';
      case EntryType.insight:
        return 'Descreva seu insight...';
      case EntryType.emotion:
        return 'Observação sobre o dia (opcional)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.type == EntryType.dream
                    ? 'Novo Sonho'
                    : widget.type == EntryType.insight
                    ? 'Novo Insight'
                    : 'Nova Emoção',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                onPressed: _save,
                icon: const Icon(
                  Icons.check_circle,
                  size: 32,
                  color: Colors.green, // Maybe change to Theme primary
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Title Field for all
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: _titleLabel,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16),

          // Dream Specific Fields
          if (widget.type == EntryType.dream) ...[
            Text(
              'Como acordou?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Cansado', 'Bem', 'Energizado', 'Assustado', 'Confuso']
                  .map((mood) {
                    final isSelected = _selectedWakeUpMood == mood;
                    return ChoiceChip(
                      label: Text(mood),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedWakeUpMood = selected ? mood : null;
                        });
                      },
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Tags', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  [
                    'Pesadelo',
                    'Lúcido',
                    'Recorrente',
                    'Fragmentado',
                    'Premonição',
                  ].map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Emotion Specific Fields
          if (widget.type == EntryType.emotion) ...[
            Text(
              'Como foi o dia? ${_intensity.round()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _intensity,
              min: 1,
              max: 5,
              divisions: 4,
              label: _intensity.round().toString(),
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (val) => setState(() => _intensity = val),
            ),
            const SizedBox(height: 16),
          ],

          // Content Field
          TextField(
            controller: _contentController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: _contentLabel,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),

          if (widget.type == EntryType.dream) ...[
            TextField(
              controller: _associationsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Associações / Resto Diurno',
                hintText: 'O que aconteceu ontem que pode ter puxado isso?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Entrada'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
