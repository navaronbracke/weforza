import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:weforza/model/settings/excluded_terms_delegate.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_empty.dart';

/// This widget represents the list of excluded terms.
///
/// This widget should be placed inside a [CustomScrollView].
class ExcludedTermsList extends StatelessWidget {
  const ExcludedTermsList({
    required this.addTermInputField,
    required this.builder,
    required this.initialData,
    required this.stream,
    this.separatorBuilder,
    super.key,
  });

  /// The input field that handles adding new terms.
  final Widget addTermInputField;

  /// The builder function that builds the individual terms.
  final Widget Function(List<ExcludedTerm> items, int index) builder;

  /// The initial list of terms.
  final List<ExcludedTerm> initialData;

  /// The builder for the item separators.
  final IndexedWidgetBuilder? separatorBuilder;

  /// The stream that provides updates to the list of terms.
  final Stream<List<ExcludedTerm>> stream;

  int? _computeActualChildCount(int itemCount) {
    int result = itemCount;

    // If the separator builder is specified, the amount of children is doubled,
    // except for the last child, which is not followed by a separator.
    if (separatorBuilder != null) {
      result = max(0, itemCount * 2 - 1);
    }

    // The add term input is the first item,
    // so add one to the result.
    return result + 1;
  }

  int? _computeSemanticIndex(Widget widget, int index) {
    // The add term input field does not need a semantic index.
    if (index == 0) {
      return null;
    }

    // Remove the initial offset from the add term input field.
    index--;

    if (separatorBuilder == null) {
      return index;
    }

    // Separators do not get semantic indexes.
    return index.isEven ? index ~/ 2 : null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExcludedTerm>>(
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        final terms = snapshot.data ?? [];

        if (terms.isEmpty) {
          return SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                addTermInputField,
                const ExcludedTermsListEmpty(),
              ],
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // The add term input field is always first.
              if (index == 0) {
                return addTermInputField;
              }

              // Remove the initial offset from the add term input field.
              index--;

              if (separatorBuilder == null) {
                return builder(terms, index);
              }

              // If there is a separator builder,
              // the real item index is only half of the reported index.
              final int itemIndex = index ~/ 2;

              if (index.isEven) {
                return builder(terms, itemIndex);
              }

              return separatorBuilder!(context, itemIndex);
            },
            childCount: _computeActualChildCount(terms.length),
            semanticIndexCallback: _computeSemanticIndex,
          ),
        );
      },
    );
  }
}
