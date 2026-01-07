import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/note_actions_sheet.dart';
import '../widgets/note_card.dart';

/// Main page displaying the notes list.
class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotesListView();
  }
}

class _NotesListView extends StatefulWidget {
  const _NotesListView();

  @override
  State<_NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<_NotesListView> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            _buildAppBar(context, theme),

            // Search bar (when searching)
            if (_isSearching) _buildSearchBar(context, theme),

            // Notes content
            Expanded(
              child: BlocBuilder<NotesCubit, NotesState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const LoadingStateWidget(),
                    loading: () => const LoadingStateWidget(),
                    loaded: (notes, isGridView, sortOption, searchQuery) {
                      return _buildNotesList(context, notes, isGridView);
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
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
      child: Row(
        children: [
          // Title
          Text(
            AppStrings.appName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),

          const Spacer(),

          // Search button
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<NotesCubit>().clearSearch();
                }
              });
            },
          ),

          // Notification button
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // Navigate to notifications or show notification
            },
          ),

          // Menu button (contains sort and view toggle)
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (menuContext) => [
              // View toggle
              PopupMenuItem(
                value: 'toggle_view',
                child: BlocSelector<NotesCubit, NotesState, bool>(
                  // Explicitly providing the bloc from the parent context since
                  // PopupMenuButton creates an overlay route where context might differ
                  bloc: context.read<NotesCubit>(),
                  selector: (state) => state.maybeWhen(
                    loaded: (_, isGridView, _, _) => isGridView,
                    orElse: () => true,
                  ),
                  builder: (selectorContext, isGridView) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isGridView ? Icons.view_list : Icons.grid_view,
                      ),
                      title: Text(
                        isGridView ? AppStrings.listView : AppStrings.gridView,
                      ),
                      dense: true,
                    );
                  },
                ),
              ),
              const PopupMenuDivider(),
              // Sort options
              const PopupMenuItem(
                value: 'sort_date',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.update),
                  title: Text(AppStrings.sortByDate),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'sort_title',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.sort_by_alpha),
                  title: Text(AppStrings.sortByTitle),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'sort_color',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.color_lens),
                  title: Text(AppStrings.sortByColor),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: theme.colorScheme.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppStrings.search,
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: theme.textTheme.bodyLarge,
                onChanged: (query) {
                  context.read<NotesCubit>().search(query);
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                iconSize: 20,
                onPressed: () {
                  _searchController.clear();
                  context.read<NotesCubit>().clearSearch();
                },
              ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList(
    BuildContext context,
    List<NoteEntity> notes,
    bool isGridView,
  ) {
    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCard(
            note: note,
            onTap: () => context.go('/note/${note.id}'),
            onMenuTap: () => _showNoteActions(context, note),
            isGridMode: true,
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () => context.go('/note/${note.id}'),
          onMenuTap: () => _showNoteActions(context, note),
          isGridMode: false,
        );
      },
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    final cubit = context.read<NotesCubit>();

    switch (action) {
      case 'toggle_view':
        cubit.toggleViewMode();
        break;
      case 'sort_date':
        cubit.changeSortOption(NoteSortOption.dateUpdated);
        break;
      case 'sort_title':
        cubit.changeSortOption(NoteSortOption.title);
        break;
      case 'sort_color':
        cubit.changeSortOption(NoteSortOption.color);
        break;
    }
  }

  void _showNoteActions(BuildContext context, NoteEntity note) {
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
