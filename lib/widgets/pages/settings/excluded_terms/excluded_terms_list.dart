import 'package:flutter/widgets.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';
import 'package:weforza/widgets/pages/settings/excluded_terms/excluded_terms_list_empty.dart';

/// This widget represents the list of excluded terms.
///
/// This widget should be placed inside a [CustomScrollView].
class ExcludedTermsList extends StatelessWidget {
  const ExcludedTermsList({
    super.key,
    required this.builder,
    required this.delegate,
  });

  /// The builder function that builds the individual items.
  final Widget Function(List<String> items, int index) builder;

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
            (context, index) => builder(terms, index),
            childCount: terms.length,
          ),
        );
      },
    );
  }
}
