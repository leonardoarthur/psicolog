import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import 'mood_calendar_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<JournalProvider>(
                builder: (context, provider, child) {
                  final entries = provider.entries;
                  if (entries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.book_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Seu diário está vazio.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      // Reverse order to show new first? Usually JournalProvider should sort.
                      // Assuming provider gives sorted or we display as comes.
                      // Let's assume provider order is correct or user wants as is.
                      return _EntryCard(entry: entry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    // Format: "Segunda, 12 Out"
    final dayName = DateFormat(
      'EEEE',
      'pt_BR',
    ).format(now).split('-')[0]; // Remove -feira
    final dayNum = DateFormat('d', 'pt_BR').format(now);
    final month = DateFormat('MMM', 'pt_BR').format(now);
    final dateStr =
        "${dayName[0].toUpperCase()}${dayName.substring(1)}, $dayNum ${month[0].toUpperCase()}${month.substring(1)}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateStr,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MoodCalendarScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month),
              ),
              IconButton(
                onPressed: () {
                  // Settings placeholder
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.nights_stay,
                  color: Colors.deepPurple,
                ),
                title: const Text('Registrar Sonho'),
                subtitle: const Text('O que você sonhou essa noite?'),
                onTap: () {
                  Navigator.pop(context);
                  _showEntryForm(context, EntryType.dream);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb, color: Colors.amber),
                title: const Text('Novo Insight'),
                subtitle: const Text('Uma ideia ou percepção.'),
                onTap: () {
                  Navigator.pop(context);
                  _showEntryForm(context, EntryType.insight);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.redAccent),
                title: const Text('Emoção Intensa'),
                subtitle: const Text('Registre o que está sentindo.'),
                onTap: () {
                  Navigator.pop(context);
                  _showEntryForm(context, EntryType.emotion);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEntryForm(BuildContext context, EntryType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _EntryFormWidget(
            type: type,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

class _EntryFormWidget extends StatefulWidget {
  final EntryType type;
  final ScrollController scrollController;

  const _EntryFormWidget({required this.type, required this.scrollController});

  @override
  State<_EntryFormWidget> createState() => _EntryFormWidgetState();
}

class _EntryFormWidgetState extends State<_EntryFormWidget> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _feelingsController = TextEditingController(); // For dreams
  final _associationsController = TextEditingController(); // For dreams
  double _intensity = 3.0; // 1-5 For emotions

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _feelingsController.dispose();
    _associationsController.dispose();
    super.dispose();
  }

  void _save() {
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
      entry.dreamFeelings = _feelingsController.text.isNotEmpty
          ? _feelingsController.text
          : null;
      entry.dreamAssociations = _associationsController.text.isNotEmpty
          ? _associationsController.text
          : null;
    } else if (widget.type == EntryType.emotion) {
      entry.emotionIntensity = _intensity.round();
    }

    context.read<JournalProvider>().addEntry(entry);
    Navigator.pop(context);
  }

  String get _titleLabel {
    switch (widget.type) {
      case EntryType.dream:
        return 'Nome do Sonho';
      case EntryType.insight:
        return 'Título do Insight';
      case EntryType.emotion:
        return 'Emoção Principal (ex: Raiva)';
    }
  }

  String get _contentLabel {
    switch (widget.type) {
      case EntryType.dream:
        return 'Relato do sonho...';
      case EntryType.insight:
        return 'Descreva seu insight...';
      case EntryType.emotion:
        return 'Por que está sentindo isso?';
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
                  color: Colors.green,
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
            TextField(
              controller: _feelingsController,
              decoration: const InputDecoration(
                labelText: 'Como acordou?',
                hintText: 'Ex: Angustiado, Aliviado',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mood),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Emotion Specific Fields
          if (widget.type == EntryType.emotion) ...[
            Text(
              'Intensidade: ${_intensity.round()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _intensity,
              min: 1,
              max: 5,
              divisions: 4,
              label: _intensity.round().toString(),
              activeColor: Colors.redAccent,
              onChanged: (val) => setState(() => _intensity = val),
            ),
            const SizedBox(height: 16),
          ],

          // Content Field (The main text)
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

          // Dream Associations
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

class _EntryCard extends StatefulWidget {
  final Entry entry;
  const _EntryCard({required this.entry});

  @override
  State<_EntryCard> createState() => _EntryCardState();
}

class _EntryCardState extends State<_EntryCard> {
  bool _isBlurred = true;

  @override
  Widget build(BuildContext context) {
    // Style determination
    Color backgroundColor;
    Color iconColor;
    IconData iconData;
    Color dateColor;

    switch (widget.entry.type) {
      case EntryType.dream:
        backgroundColor = Colors.deepPurple.shade50;
        iconColor = Colors.deepPurple;
        iconData = Icons.nights_stay;
        dateColor = Colors.deepPurple.shade300;
        break;
      case EntryType.insight:
        backgroundColor = Colors.grey.shade50; // Minimalist
        iconColor = Colors.amber.shade800;
        iconData = Icons.lightbulb_outline;
        dateColor = Colors.grey;
        break;
      case EntryType.emotion:
        backgroundColor = Colors.red.shade50;
        iconColor = Colors.redAccent;
        iconData = Icons.flash_on;
        dateColor = Colors.red.shade300;
        break;
    }

    final dateStr = DateFormat('dd/MM HH:mm').format(widget.entry.timestamp);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isBlurred = !_isBlurred;
        });
      },
      onLongPress: () {
        setState(() {
          _isBlurred = false;
        });
      },
      onLongPressUp: () {
        setState(() {
          // Optional: Only unblur while holding? The prompt said "segurar o dedo", implying hold to view?
          // Or "expandir/clicar" to view permanently.
          // Prompt: "O usuário deve conseguir ver o conteúdo apenas ao clicar no card (expandir) ou segurar o dedo (long press)."
          // Let's make tap toggle blur, long press unblur while held (if we could, but longPressUp is reliable).
          // Actually, let's just stick to toggle on tap for simplicity and better UX.
          _isBlurred = true;
        });
      },
      child: Card(
        color: backgroundColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title + Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.entry.title ??
                              _itemTypeTitle(widget.entry.type),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          dateStr,
                          style: TextStyle(color: dateColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (widget.entry.emotionIntensity != null)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${widget.entry.emotionIntensity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Privacy Blur Section
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _isBlurred
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    children: [
                      Text(
                        widget.entry.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              color: Colors.grey.withValues(alpha: 0.1),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entry.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    if (widget.entry.dreamFeelings != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Sentimento: ${widget.entry.dreamFeelings}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],

                    if (widget.entry.dreamAssociations != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Associações: ${widget.entry.dreamAssociations}",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _itemTypeTitle(EntryType type) {
    switch (type) {
      case EntryType.dream:
        return "Sonho";
      case EntryType.insight:
        return "Insight";
      case EntryType.emotion:
        return "Emoção";
    }
  }
}
