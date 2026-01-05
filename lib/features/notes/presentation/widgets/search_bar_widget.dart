/// Search bar widget for searching notes.
///
/// A custom search bar with animation and clear button.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

/// A custom search bar widget for searching notes.
class SearchBarWidget extends StatefulWidget {
  /// Current search query
  final String? initialQuery;

  /// Callback when the search query changes
  final ValueChanged<String> onChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when search is cleared
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    this.initialQuery,
    required this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _focusNode = FocusNode();
    _showClear = _controller.text.isNotEmpty;

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClear != hasText) {
      setState(() => _showClear = hasText);
    }
    widget.onChanged(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear?.call();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),

          // Search icon
          Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 22,
          ),

          const SizedBox(width: 12),

          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: AppStrings.search,
                hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: theme.textTheme.bodyLarge,
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSubmitted,
            ),
          ),

          // Clear button
          AnimatedOpacity(
            opacity: _showClear ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedScale(
              scale: _showClear ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                icon: const Icon(Icons.clear),
                iconSize: 20,
                onPressed: _showClear ? _clearSearch : null,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

/// Expandable search bar in app bar.
class ExpandableSearchBar extends StatefulWidget {
  /// Callback when the search query changes
  final ValueChanged<String> onChanged;

  /// Callback when search is cleared/closed
  final VoidCallback? onClose;

  const ExpandableSearchBar({super.key, required this.onChanged, this.onClose});

  @override
  State<ExpandableSearchBar> createState() => _ExpandableSearchBarState();
}

class _ExpandableSearchBarState extends State<ExpandableSearchBar>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        _focusNode.requestFocus();
      } else {
        _animationController.reverse();
        _controller.clear();
        widget.onClose?.call();
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _isExpanded ? 200 + (100 * _animation.value) : 48,
          height: 48,
          decoration: BoxDecoration(
            color: _isExpanded
                ? theme.colorScheme.surfaceContainerHigh
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              // Search/close button
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.search,
                    key: ValueKey(_isExpanded),
                  ),
                ),
                onPressed: _toggleSearch,
              ),

              // Expandable text field
              if (_isExpanded)
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onChanged,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
