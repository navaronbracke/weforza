import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_empty.dart';

/// This widget represents the list of excluded terms.
///
/// This widget should be placed inside a [CustomScrollView].
class ExcludedTermsList extends StatelessWidget {
  const new({required this.addTermInputField, required this.builder, required this.listenable, super.key});

  /// The input field that handles adding new terms.
  final Widget addTermInputField;

  /// The builder function that builds the individual terms.
  final Widget Function(List<ExcludedTerm> items, int index) builder;

  /// The [ValueListenable] that provides updates to the list of terms.
  final ValueListenable<Set<ExcludedTerm>> listenable;

  int? _computeSemanticIndex(Widget widget, int index) {
    // The add term input field does not need a semantic index.
    if (index == 0) {
      return null;
    }

    // Remove the initial offset from the add term input field.
    return index - 1;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<ExcludedTerm>>(
      valueListenable: listenable,
      builder: (context, terms, _) {
        if (terms.isEmpty) {
          return SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [addTermInputField, const ExcludedTermsListEmpty()],
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
              return builder([...terms], index - 1);
            },
            // The add term input is the first item.
            childCount: terms.length + 1,
            semanticIndexCallback: _computeSemanticIndex,
          ),
        );
      },
    );
  }
}
