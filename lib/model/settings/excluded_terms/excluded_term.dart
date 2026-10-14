/// This class represents a single excluded term.
///
/// Two excluded terms are only equal if their [term]s are equal.
class ExcludedTerm implements Comparable<ExcludedTerm> {
  /// Construct a new excluded term.
  const ExcludedTerm(this.term);

  /// The current value of the excluded term.
  final String term;

  @override
  int compareTo(ExcludedTerm other) => term.compareTo(other.term);

  @override
  int get hashCode => term.hashCode;

  @override
  bool operator ==(Object other) => other is ExcludedTerm && term == other.term;
}
