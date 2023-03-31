import 'package:flutter/widgets.dart';
import 'package:weforza/model/excluded_terms_delegate.dart';

/// This widget represents the list of excluded terms.
class ExcludedTermsList extends StatelessWidget {
  const ExcludedTermsList({
    super.key,
    required this.builder,
    required this.delegate,
  });

  /// The builder that builds the list of excluded terms.
  final Widget Function(List<String> items) builder;

  /// The delegate that provides the list of terms.
  final ExcludedTermsDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      initialData: delegate.terms,
      stream: delegate.stream,
      builder: (context, snapshot) => builder(snapshot.data ?? []),
    );
  }
}
