import 'package:flutter/widgets.dart';
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
    super.key,
  });

  /// The input field that handles adding new terms.
  final Widget addTermInputField;

  /// The builder function that builds the individual terms.
  final Widget Function(List<String> items, int index) builder;

  /// The initial list of terms.
  final List<String> initialData;

  /// The stream that provides updates to the list of terms.
  final Stream<List<String>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
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
              if (index == 0) {
                return addTermInputField;
              }

              return builder(terms, index - 1);
            },
            // The add term input is the first item.
            childCount: terms.length + 1,
          ),
        );
      },
    );
  }
}
