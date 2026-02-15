import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import '../widgets/background_wrapper.dart';
import 'package:psicolog/l10n/app_localizations.dart';

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

  Future<void> _save() async {
    // If dream, content can be empty if title is present? Or vice versa.
    // Plan: Title optional. Content required? Maybe allow empty description if tags present?
    // Let's enforce some content or title.
    if (_contentController.text.isEmpty && _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.writeSomethingToSave),
        ),
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

    await context.read<JournalProvider>().addEntry(entry);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _titleLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.type) {
      case EntryType.dream:
        return l10n.dreamTitleHint;
      case EntryType.insight:
        return l10n.insightTitleHint;
      case EntryType.emotion:
        return l10n.emotionTitleHint;
      case EntryType.therapy:
        return l10n.therapyTitleHint;
    }
  }

  String _contentLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.type) {
      case EntryType.dream:
        return l10n.dreamContentHint;
      case EntryType.insight:
        return l10n.insightContentHint;
      case EntryType.emotion:
        return l10n.emotionContentHint;
      case EntryType.therapy:
        return l10n.therapyContentHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optimization: using Scaffold to handle keyboard resize natively avoids
    // manual rebuilds triggered by MediaQuery.viewInsets on every frame.
    // Optimization: Put the animated background in a Stack behind the Scaffold.
    // The background is wrapped in a Positioned.fill/SizedBox.expand to ignore keyboard resize.
    // The Scaffold background is transparent.
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundWrapper(child: SizedBox.shrink()),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              widget.entryToEdit == null
                  ? (widget.type == EntryType.dream
                        ? AppLocalizations.of(context)!.newDream
                        : widget.type == EntryType.insight
                        ? AppLocalizations.of(context)!.newInsight
                        : widget.type == EntryType.therapy
                        ? AppLocalizations.of(context)!.newTherapy
                        : AppLocalizations.of(context)!.newEmotion)
                  : (widget.type == EntryType.dream
                        ? AppLocalizations.of(context)!.editDream
                        : widget.type == EntryType.insight
                        ? AppLocalizations.of(context)!.editInsight
                        : widget.type == EntryType.therapy
                        ? AppLocalizations.of(context)!.editTherapy
                        : AppLocalizations.of(context)!.editEmotion),
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
                  AppLocalizations.of(context)!.save.toUpperCase(),
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
          body: ListView(
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
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: _titleLabel(context),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (widget.type == EntryType.dream) ...[
                Text(
                  AppLocalizations.of(context)!.howDidYouWakeUp,
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
                      ].map((moodKey) {
                        final l10n = AppLocalizations.of(context)!;
                        String label;
                        switch (moodKey) {
                          case 'Cansado':
                            label = l10n.moodTired;
                            break;
                          case 'Bem':
                            label = l10n.moodGood;
                            break;
                          case 'Energizado':
                            label = l10n.moodEnergized;
                            break;
                          case 'Assustado':
                            label = l10n.moodScared;
                            break;
                          case 'Confuso':
                            label = l10n.moodConfused;
                            break;
                          default:
                            label = moodKey;
                        }

                        final isSelected = _selectedWakeUpMood == moodKey;
                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedWakeUpMood = selected ? moodKey : null;
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.tagsLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
                      ].map((tagKey) {
                        final l10n = AppLocalizations.of(context)!;
                        String label;
                        switch (tagKey) {
                          case 'Pesadelo':
                            label = l10n.tagNightmare;
                            break;
                          case 'Lúcido':
                            label = l10n.tagLucid;
                            break;
                          case 'Recorrente':
                            label = l10n.tagRecurrent;
                            break;
                          case 'Fragmentado':
                            label = l10n.tagFragmented;
                            break;
                          case 'Premonição':
                            label = l10n.tagPremonition;
                            break;
                          default:
                            label = tagKey;
                        }

                        final isSelected = _selectedTags.contains(tagKey);
                        return FilterChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tagKey);
                              } else {
                                _selectedTags.remove(tagKey);
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
                  '${AppLocalizations.of(context)!.howWasYourDay} ${_intensity.round()}',
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
                textCapitalization: TextCapitalization.sentences,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: _contentLabel(context),
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              if (widget.type == EntryType.therapy) ...[
                TextField(
                  controller: _keyLessonController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.reflectionQuestion,
                    hintText: AppLocalizations.of(context)!.reflectionHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.star_border),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (widget.type == EntryType.dream) ...[
                TextField(
                  controller: _associationsController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.associationsLabel,
                    hintText: AppLocalizations.of(context)!.associationsHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 40), // Extra space at bottom
            ],
          ),
        ),
      ],
    );
  }
}
