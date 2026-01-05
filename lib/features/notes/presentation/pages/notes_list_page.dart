/// Notes list page - main home page.
///
/// Displays all notes in a grid or list view with search,
/// sort, and filter capabilities.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/repositories/note_repository.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/note_actions_sheet.dart';
import '../widgets/note_card.dart';
import '../widgets/search_bar_widget.dart';

/// Main page displaying the notes list.
class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotesCubit>()..loadNotes(),
      child: const _NotesListView(),
    );
  }
}

class _NotesListView extends StatefulWidget {
  const _NotesListView();

  @override
  State<_NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<_NotesListView> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar area
            _buildAppBar(context, theme),

            // Search bar (when searching)
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SearchBarWidget(
                  onChanged: (query) {
                    context.read<NotesCubit>().search(query);
                  },
                  onClear: () {
                    context.read<NotesCubit>().clearSearch();
                    setState(() => _isSearching = false);
                  },
                ),
              ),

            // Notes content
            Expanded(
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const LoadingStateWidget(),
                    loading: () => const LoadingStateWidget(),
                    loaded: (notes, isGridView, sortOption, searchQuery) {
                      return _buildNotesList(
                        context,
                        notes,
                        isGridView,
                        searchQuery != null,
                      );
                    },
                    empty: () => _isSearching
                        ? EmptyStateWidget.search()
                        : const EmptyStateWidget(),
                    error: (message) => ErrorStateWidget(
                      message: message,
                      onRetry: () => context.read<NotesCubit>().loadNotes(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/note/new'),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newNote),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          // Title
          if (!_isSearching)
            Text(
              AppStrings.notes,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

          const Spacer(),

          // Search button
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  context.read<NotesCubit>().clearSearch();
                }
              });
            },
            tooltip: 'Search',
          ),

          // View toggle button
          BlocSelector<NotesCubit, NotesState, bool>(
            selector: (state) => state.maybeWhen(
              loaded: (_, isGridView, _, _) => isGridView,
              orElse: () => true,
            ),
            builder: (context, isGridView) {
              return IconButton(
                icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                onPressed: () => context.read<NotesCubit>().toggleViewMode(),
                tooltip: isGridView ? AppStrings.listView : AppStrings.gridView,
              );
            },
          ),

          // Sort menu
          PopupMenuButton<NoteSortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            onSelected: (option) {
              context.read<NotesCubit>().changeSortOption(option);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: NoteSortOption.dateUpdated,
                child: ListTile(
                  leading: Icon(Icons.update),
                  title: Text(AppStrings.sortByDate),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: NoteSortOption.title,
                child: ListTile(
                  leading: Icon(Icons.sort_by_alpha),
                  title: Text(AppStrings.sortByTitle),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: NoteSortOption.color,
                child: ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text(AppStrings.sortByColor),
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

  Widget _buildNotesList(
    BuildContext context,
    List notes,
    bool isGridView,
    bool isSearching,
  ) {
    if (isGridView) {
      return _buildGridView(context, notes);
    } else {
      return _buildListView(context, notes);
    }
  }

  Widget _buildGridView(BuildContext context, List notes) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          isGridView: true,
          onTap: () => context.go('/note/${note.id}'),
          onLongPress: () => _showNoteActions(context, note),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, List notes) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteListTile(
          note: note,
          onTap: () => context.go('/note/${note.id}'),
          onLongPress: () => _showNoteActions(context, note),
        );
      },
    );
  }

  void _showNoteActions(BuildContext context, dynamic note) {
    NoteActionsSheet.show(
      context: context,
      note: note,
      onTogglePin: () => context.read<NotesCubit>().togglePin(note.id),
      onDelete: () => context.read<NotesCubit>().removeNote(note.id),
      onColorChanged: (color) {
        context.read<NotesCubit>().changeNoteColor(note.id, color);
      },
    );
  }
}
