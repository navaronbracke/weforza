import 'package:flutter/widgets.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/edit_excluded_term_input_field.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_empty.dart';

/// This widget represents the list of excluded terms.
///
/// This widget should be placed inside a [CustomScrollView].
class ExcludedTermsList extends StatelessWidget {
  const ExcludedTermsList({
    super.key,
    this.decorator,
    required this.delegate,
  });

  /// The function that decorates a given child.
  final Widget? Function(Widget, int, List<String>)? decorator;

  /// The delegate that provides the list of terms.
  final ExcludedTermsDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      initialData: delegate.terms,
      stream: delegate.stream,
      builder: (context, snapshot) {
        final terms = snapshot.data ?? [];

        if (terms.isEmpty) {
          return const SliverToBoxAdapter(
            child: ExcludedTermsListEmpty(),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final term = terms[index];

              final child = EditExcludedTermInputField(
                key: ValueKey(term),
                delegate: delegate,
                index: index,
                term: term,
              );

              return decorator?.call(child, index, terms) ?? child;
            },
            childCount: terms.length,
          ),
        );
      },
    );
  }
}
