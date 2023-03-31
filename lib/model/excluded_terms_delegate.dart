import 'package:rxdart/subjects.dart';
import 'package:weforza/generated/l10n.dart';

/// This class represents a delegate
/// that will manage the excluded terms for the scan filter.
class ExcludedTermsDelegate {
  /// The default constructor.
  ExcludedTermsDelegate({
    List<String> initialValue = const [],
  }) : _termsController = BehaviorSubject.seeded(initialValue);

  final BehaviorSubject<List<String>> _termsController;

  /// The max length for an excluded term.
  final int maxLength = 16;

  final whitespaceMatcher = RegExp(r'\s');

  /// Get the stream of excluded terms.
  Stream<List<String>> get stream => _termsController;

  /// Get the current list of terms.
  List<String> get terms => _termsController.value;

  /// Add the given [value] to the list of terms.
  void addTerm(String value) {
    final terms = _termsController.value;

    terms.add(value);
    terms.sort((a, b) => a.compareTo(b));

    _termsController.add(terms);
  }

  /// Delete the given [value] from the list of terms.
  void deleteTerm(String value) {
    final terms = _termsController.value;

    terms.remove(value);

    _termsController.add(terms);
  }

  /// Replace the item at [index] with [newValue].
  void editTerm(String newValue, int index) {
    final terms = _termsController.value;

    terms[index] = newValue;
    terms.sort((a, b) => a.compareTo(b));

    _termsController.add(terms);
  }

  /// Checks whether the given [value] already exists in the list of terms.
  bool exists(String value) => _termsController.value.contains(value);

  /// Validates the given [term].
  ///
  /// The [originalValue] is the value of the term
  /// before the `TextEditingValue` changed.
  /// This value is used to prevent a term from being a duplicate of itself.
  ///
  /// Returns an error message if the value is null, only whitespace or empty.
  /// Returns an error message if the value exceeded the [maxLength].
  /// Returns an error message if the value changed from its [originalValue]
  /// and now matches another term in the list of terms, besides itself.
  /// Returns null otherwise.
  String? validateTerm(String? term, S translator, {String? originalValue}) {
    if (term == null || term.trim().isEmpty) {
      return translator.DisallowedWordRequired;
    }

    if (whitespaceMatcher.hasMatch(term)) {
      return translator.DisallowedWordNoWhitespace;
    }

    if (term.length > maxLength) {
      return translator.DisallowedWordMaxLength(maxLength);
    }

    // If the term is equal to the original value,
    // then the term is equal to itself, which is allowed.
    if (term != originalValue && exists(term)) {
      return translator.DisallowedWordExists;
    }

    return null;
  }

  /// Dispose of this delegate.
  void dispose() {
    _termsController.close();
  }
}
