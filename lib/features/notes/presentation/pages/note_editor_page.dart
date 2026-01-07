import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/note_editor_cubit.dart';
import '../cubit/note_editor_state.dart';
import '../widgets/color_picker_widget.dart';

/// Page for creating or editing a note.
class NoteEditorPage extends StatelessWidget {
  /// ID of the note to edit, or null for a new note
  final String? noteId;

  const NoteEditorPage({super.key, this.noteId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NoteEditorCubit>()..initialize(noteId: noteId),
      child: const _NoteEditorView(),
    );
  }
}

class _NoteEditorView extends StatefulWidget {
  const _NoteEditorView();

  @override
  State<_NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<_NoteEditorView> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _syncControllersWithState(NoteEditorState state) {
    if (_isInitialized) return;

    state.maybeWhen(
      editing: (note, isNewNote, hasUnsavedChanges) {
        if (note.title.isNotEmpty) {
          _titleController.text = note.title;
        }
        if (note.content.isNotEmpty) {
          _contentController.text = note.content;
        }
        _isInitialized = true;
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteEditorCubit, NoteEditorState>(
      listener: (context, state) {
        state.maybeWhen(
          saved: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Note saved'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          deleted: () {
            context.go('/');
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          orElse: () {},
        );

        _syncControllersWithState(state);
      },
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoading(context),
          loading: () => _buildLoading(context),
          editing: (note, isNewNote, hasChanges) {
            return _buildEditor(
              context,
              noteColor: note.color,
              isPinned: note.isPinned,
              isNewNote: isNewNote,
            );
          },
          saving: () => _buildEditor(context, isSaving: true),
          saved: () => _buildEditor(context),
          deleted: () => _buildLoading(context),
          error: (message) => _buildError(context, message),
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text('Error', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditor(
    BuildContext context, {
    int? noteColor,
    bool isPinned = false,
    bool isNewNote = true,
    bool isSaving = false,
  }) {
    final cubit = context.read<NoteEditorCubit>();
    final theme = Theme.of(context);
    final color = noteColor ?? cubit.currentColor;
    final backgroundColor = NoteColors.fromInt(color);

    // Determine text colors based on background
    final isDark = backgroundColor.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.black38;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => context.go('/'),
        ),
        actions: [
          // Saving indicator
          if (isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: iconColor,
                  ),
                ),
              ),
            ),

          // Pin button
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: isPinned ? AppColors.pinned : iconColor,
            ),
            onPressed: cubit.togglePin,
            tooltip: isPinned ? AppStrings.unpin : AppStrings.pin,
          ),

          // Color picker
          IconButton(
            icon: Icon(Icons.palette_outlined, color: iconColor),
            onPressed: () => _showColorPicker(context, cubit, color),
            tooltip: AppStrings.changeColor,
          ),

          // More options
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: iconColor),
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context, cubit);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    AppStrings.delete,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Last edited timestamp
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: hintColor),
                        const SizedBox(width: 6),
                        Text(
                          'Last edited: ${AppStrings.formatDate(DateTime.now())}', // Simplified for now
                          style: TextStyle(fontSize: 12, color: hintColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title field
                    TextField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      decoration: InputDecoration(
                        hintText: AppStrings.titleHint,
                        hintStyle: TextStyle(
                          color: hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: cubit.updateTitle,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 24),

                    // Content field
                    TextField(
                      controller: _contentController,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor.withValues(alpha: 0.85),
                        height: 1.6,
                      ),
                      decoration: InputDecoration(
                        hintText: AppStrings.contentHint,
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: cubit.updateContent,
                      maxLines: null,
                      minLines: 20,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(
    BuildContext context,
    NoteEditorCubit cubit,
    int currentColor,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.changeColor,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ColorPickerGrid(
                selectedColor: currentColor,
                onColorSelected: (color) {
                  cubit.updateColor(color);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, NoteEditorCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              cubit.deleteCurrentNote();
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
