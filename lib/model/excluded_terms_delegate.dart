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
  /// Returns an error message if the term is invalid, or null otherwise.
  String? validateTerm(String? term, S translator) {
    if (term == null || term.trim().isEmpty) {
      return translator.KeywordRequired;
    }

    if (term.length > maxLength) {
      return translator.KeywordMaxLength(maxLength);
    }

    if (exists(term)) {
      return translator.KeywordExists;
    }

    return null;
  }

  /// Dispose of this delegate.
  void dispose() {
    _termsController.close();
  }
}
