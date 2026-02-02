import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import '../widgets/background_wrapper.dart';

class EntryFormWidget extends StatefulWidget {
  final EntryType type;
  final ScrollController scrollController;

  const EntryFormWidget({
    super.key,
    required this.type,
    required this.scrollController,
    this.entryToEdit,
  });

  final Entry? entryToEdit;

  @override
  State<EntryFormWidget> createState() => _EntryFormWidgetState();
}

class _EntryFormWidgetState extends State<EntryFormWidget> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _associationsController = TextEditingController();
  final _keyLessonController = TextEditingController();

  String? _selectedWakeUpMood;
  final List<String> _selectedTags = [];
  double _intensity = 3.0;

  @override
  void initState() {
    super.initState();
    if (widget.entryToEdit != null) {
      final e = widget.entryToEdit!;
      _titleController.text = e.title ?? '';
      _contentController.text = e.content;
      _associationsController.text = e.dreamAssociations ?? '';
      _selectedWakeUpMood = e.wakeUpMood;
      if (e.dreamTags != null) {
        _selectedTags.addAll(e.dreamTags!);
      }
      if (e.dailyMood != null) {
        _intensity = e.dailyMood!.toDouble();
      }
      _keyLessonController.text = e.therapyKeyLesson ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _associationsController.dispose();
    _keyLessonController.dispose();
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
      ..timestamp = widget.entryToEdit?.timestamp ?? DateTime.now();

    // If editing, preserve ID and pinned status
    if (widget.entryToEdit != null) {
      entry.id = widget.entryToEdit!.id;
      entry.isPinned = widget.entryToEdit!.isPinned;
    }

    if (widget.type == EntryType.dream) {
      entry.wakeUpMood = _selectedWakeUpMood;
      entry.dreamTags = _selectedTags;
      entry.dreamAssociations = _associationsController.text.isNotEmpty
          ? _associationsController.text
          : null;
    } else if (widget.type == EntryType.emotion) {
      entry.dailyMood = _intensity.round();
    } else if (widget.type == EntryType.therapy) {
      entry.therapyKeyLesson = _keyLessonController.text;
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
      case EntryType.therapy:
        return 'Título da Sessão (Opcional)';
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
      case EntryType.therapy:
        return 'Fale um pouco sobre a sessão...';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optimization: using Scaffold to handle keyboard resize natively avoids
    // manual rebuilds triggered by MediaQuery.viewInsets on every frame.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entryToEdit == null
              ? (widget.type == EntryType.dream
                    ? 'Novo Sonho'
                    : widget.type == EntryType.insight
                    ? 'Novo Insight'
                    : widget.type == EntryType.therapy
                    ? 'Nova Sessão'
                    : 'Novo Humor')
              : (widget.type == EntryType.dream
                    ? 'Editar Sonho'
                    : widget.type == EntryType.insight
                    ? 'Editar Insight'
                    : widget.type == EntryType.therapy
                    ? 'Editar Sessão'
                    : 'Editar Emoção'),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // In dark mode, background is the gradient (dark) -> want White text
        // In light mode, background is the scaffold (light) -> want onSurface (dark) text
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'SALVAR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: BackgroundWrapper(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            kToolbarHeight + MediaQuery.of(context).padding.top + 16,
            16,
            16,
          ),
          children: [
            // Row removed (now in AppBar)

            // Title Field for all EXCEPT Therapy
            if (widget.type != EntryType.therapy) ...[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: _titleLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Dream Specific Fields
            if (widget.type == EntryType.dream) ...[
              Text(
                'Como acordou?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    [
                      'Cansado',
                      'Bem',
                      'Energizado',
                      'Assustado',
                      'Confuso',
                    ].map((mood) {
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
                    }).toList(),
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

            if (widget.type == EntryType.therapy) ...[
              TextField(
                controller: _keyLessonController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'O que mais te fez refletir dessa vez?',
                  hintText: 'O que você quer lembrar dessa sessão?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star_border),
                ),
              ),
              const SizedBox(height: 16),
            ],

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

            const SizedBox(height: 40), // Extra space at bottom
          ],
        ),
      ),
    );
  }
}
