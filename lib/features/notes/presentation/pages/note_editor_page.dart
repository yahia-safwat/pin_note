/// Note editor page for creating and editing notes.
///
/// Provides a full-screen editor with auto-save functionality.
library;

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
  bool _showColorPicker = false;

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
    state.maybeWhen(
      editing: (note, isNewNote, hasUnsavedChanges) {
        // Only sync if controllers are empty (first load)
        // or if note was just loaded
        if (_titleController.text.isEmpty && note.title.isNotEmpty) {
          _titleController.text = note.title;
        }
        if (_contentController.text.isEmpty && note.content.isNotEmpty) {
          _contentController.text = note.content;
        }
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
              ),
            );
          },
          orElse: () {},
        );

        // Sync controllers on first load
        _syncControllersWithState(state);
      },
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoading(),
          loading: () => _buildLoading(),
          editing: (note, isNewNote, hasChanges) {
            return _buildEditor(context, note.color, note.isPinned);
          },
          saving: () => _buildEditor(context, null, false, isSaving: true),
          saved: () => _buildEditor(context, null, false),
          deleted: () => _buildLoading(),
          error: (message) => _buildError(context, message),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildError(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor(
    BuildContext context,
    int? noteColor,
    bool isPinned, {
    bool isSaving = false,
  }) {
    final cubit = context.read<NoteEditorCubit>();
    final theme = Theme.of(context);
    final color = noteColor ?? cubit.currentColor;
    final backgroundColor = NoteColors.fromInt(color);
    final isDarkBackground = backgroundColor.computeLuminance() < 0.5;
    final contentColor = isDarkBackground ? Colors.white : Colors.black87;
    final hintColor = isDarkBackground ? Colors.white60 : Colors.black45;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(context, cubit, isPinned, contentColor, isSaving),

            // Divider
            Divider(color: contentColor.withValues(alpha: 0.1), height: 1),

            // Editor content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Title field
                    TextField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: contentColor,
                      ),
                      decoration: InputDecoration(
                        hintText: AppStrings.titleHint,
                        hintStyle: TextStyle(color: hintColor),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: cubit.updateTitle,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 16),

                    // Content field
                    TextField(
                      controller: _contentController,
                      style: TextStyle(
                        fontSize: 16,
                        color: contentColor,
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
                      minLines: 10,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ],
                ),
              ),
            ),

            // Color picker (shown when expanded)
            if (_showColorPicker)
              Container(
                color: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ColorPickerWidget(
                  selectedColor: color,
                  onColorSelected: (newColor) {
                    cubit.updateColor(newColor);
                    setState(() => _showColorPicker = false);
                  },
                ),
              ),

            // Bottom toolbar
            _buildBottomToolbar(context, cubit, color, isPinned),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    NoteEditorCubit cubit,
    bool isPinned,
    Color contentColor,
    bool isSaving,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back, color: contentColor),
            onPressed: () => context.go('/'),
          ),

          const Spacer(),

          // Saving indicator
          if (isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: contentColor,
                ),
              ),
            ),

          // Pin button
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: isPinned ? AppColors.pinned : contentColor,
            ),
            onPressed: cubit.togglePin,
            tooltip: isPinned ? AppStrings.unpin : AppStrings.pin,
          ),

          // More options
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: contentColor),
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _confirmDelete(context, cubit);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    AppStrings.delete,
                    style: TextStyle(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar(
    BuildContext context,
    NoteEditorCubit cubit,
    int color,
    bool isPinned,
  ) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Color button
            IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.color_lens_outlined),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: NoteColors.fromInt(color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                setState(() => _showColorPicker = !_showColorPicker);
              },
              tooltip: AppStrings.changeColor,
            ),

            const Spacer(),

            // Character count (optional enhancement)
            Text(
              '${_contentController.text.length} characters',
              style: theme.textTheme.bodySmall,
            ),
          ],
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
