import 'dart:async';

import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/settings/excluded_terms/excluded_term.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This class represents a delegate that manages the excluded terms for the scan filter.
class ExcludedTermsDelegate {
  /// The default constructor.
  ExcludedTermsDelegate({required this._settingsDelegate, Set<ExcludedTerm> initialValue = const {}})
    : _termsNotifier = ValueNotifier(initialValue);

  final SettingsNotifier _settingsDelegate;
  final ValueNotifier<Set<ExcludedTerm>> _termsNotifier;

  /// The max length for an [ExcludedTerm].
  static const int maxLength = 16;

  /// Get the [ValueListenable] of [ExcludedTerm]s.
  ValueListenable<Set<ExcludedTerm>> get listenable => _termsNotifier;

  /// Save the given [terms].
  void _saveTerms(Set<ExcludedTerm> terms) {
    unawaited(
      _settingsDelegate.saveExcludedTerms({for (final ExcludedTerm value in terms) value.term}).catchError((_) {
        // If the terms could not be saved, do nothing.
      }),
    );
  }

  /// Add the given [value] to the list of terms.
  void addTerm(String value) {
    final List<ExcludedTerm> newTermsList = [
      for (final ExcludedTerm term in _termsNotifier.value) term,
      ExcludedTerm(value),
    ]..sort((a, b) => a.compareTo(b));

    // A Set cannot be sorted so use insertion order.
    final Set<ExcludedTerm> newTerms = Set.of(newTermsList);

    _termsNotifier.value = newTerms;
    _saveTerms(newTerms);
  }

  /// Delete the given [value] from the list of terms.
  void deleteTerm(ExcludedTerm value) {
    final terms = Set.of(_termsNotifier.value);

    if (terms.remove(value)) {
      _termsNotifier.value = terms;
      _saveTerms(terms);
    }
  }

  /// Replace the item at [index] with [newValue].
  void editTerm(String newValue, int index) {
    final oldTerms = List.of(_termsNotifier.value);

    oldTerms[index] = ExcludedTerm(newValue);
    oldTerms.sort((a, b) => a.compareTo(b));

    final newTerms = Set.of(oldTerms);

    _termsNotifier.value = newTerms;
    _saveTerms(newTerms);
  }

  /// Validates the given [term].
  ///
  /// The [originalValue] is the value of the term
  /// before the `TextEditingValue` changed.
  /// This value is used to prevent a term from being a duplicate of itself.
  ///
  /// Returns an error message if the value is null or empty.
  /// Returns an error message if the value exceeded the [maxLength].
  /// Returns an error message if the value changed from its [originalValue]
  /// and now matches another term in the list of terms, besides itself.
  /// Returns null otherwise.
  String? validateTerm(String? term, S translator, {String? originalValue}) {
    if (term == null || term.isEmpty) {
      return translator.disallowedWordRequired;
    }

    if (term.length > maxLength) {
      return translator.disallowedWordMaxLength(maxLength);
    }

    // Create a temporary value to use when checking existence.
    final ExcludedTerm valueForText = ExcludedTerm(term);

    final bool exists = _termsNotifier.value.contains(valueForText);

    // If the term is equal to the original value,
    // then the term is equal to itself, which is allowed.
    if (term != originalValue && exists) {
      return translator.disallowedWordExists;
    }

    return null;
  }

  /// Dispose of this delegate.
  void dispose() {
    _termsNotifier.dispose();
  }
}
