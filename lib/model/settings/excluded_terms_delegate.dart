import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/settings_provider.dart';

/// This class represents a single excluded term.
///
/// Two excluded terms are only equal if their [term]s are equal.
class ExcludedTerm implements Comparable<ExcludedTerm> {
  /// Construct a new excluded term.
  ExcludedTerm({
    required this.term,
  }) : controller = TextEditingController(text: term);

  /// The controller that manages the [TextEditingValue] which represents the
  /// term that is being composed.
  final TextEditingController controller;

  /// The current value of the excluded term.
  ///
  /// When the [controller]'s text was committed,
  /// then this value is updated to the current [TextEditingController.text].
  String term;

  @override
  int compareTo(ExcludedTerm other) => term.compareTo(other.term);

  void setValue(String value) {
    if (term != value) {
      term = value;
      controller.text = term;
    }
  }

  /// Dispose of this excluded term.
  void dispose() => controller.dispose();

  @override
  int get hashCode => term.hashCode;

  @override
  bool operator ==(Object other) => other is ExcludedTerm && term == other.term;
}

/// This class represents a delegate that manages the excluded terms for the scan filter.
class ExcludedTermsDelegate {
  /// The default constructor.
  ExcludedTermsDelegate({
    required SettingsNotifier settingsDelegate,
    List<ExcludedTerm> initialValue = const [],
  })  : _settingsDelegate = settingsDelegate,
        _termsController = BehaviorSubject.seeded(initialValue);

  final BehaviorSubject<List<ExcludedTerm>> _termsController;

  /// The max length for an excluded term.
  final int maxLength = 16;

  final whitespaceMatcher = RegExp(r'\s');

  final SettingsNotifier _settingsDelegate;

  /// Get the stream of excluded terms.
  Stream<List<ExcludedTerm>> get stream => _termsController;

  /// Get the current list of terms.
  List<ExcludedTerm> get terms => _termsController.value;

  /// Save the given [terms].
  void _saveTerms(List<ExcludedTerm> terms) {
    // Grab the committed term values.
    final values = terms.map((t) => t.term).toSet();

    unawaited(_settingsDelegate.saveExcludedTerms(values).catchError((_) {
      // If the terms could not be saved, do nothing.
    }));
  }

  /// Add the given [value] to the list of terms.
  ///
  /// This method does not validate
  /// whether an [ExcludedTerm] with the given [value] already exists.
  void addTerm(String value) {
    final terms = _termsController.value;

    terms.add(ExcludedTerm(term: value));
    terms.sort((a, b) => a.compareTo(b));

    _termsController.add(terms);
    _saveTerms(terms);
  }

  /// Delete the given [value] from the list of terms.
  void deleteTerm(ExcludedTerm value) {
    final terms = _termsController.value;

    if (terms.remove(value)) {
      _termsController.add(terms);
      _saveTerms(terms);

      // Dispose the underlying controller by the end of the current frame,
      // so that a consumer has time to detach from it.
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        value.dispose();
      });
    }
  }

  /// Replace the item at [index] with [newValue].
  void editTerm(String newValue, int index) {
    final terms = _termsController.value;

    terms[index].setValue(newValue);
    terms.sort((a, b) => a.compareTo(b));

    _termsController.add(terms);
    _saveTerms(terms);
  }

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
    if (term == null || term.isEmpty) {
      return translator.disallowedWordRequired;
    }

    if (whitespaceMatcher.hasMatch(term)) {
      return translator.disallowedWordNoWhitespace;
    }

    if (term.length > maxLength) {
      return translator.disallowedWordMaxLength(maxLength);
    }

    // Create a temporary value to use when checking existence.
    final ExcludedTerm valueForText = ExcludedTerm(term: term);

    final bool exists = _termsController.value.contains(valueForText);

    valueForText.dispose(); // Clean up the temporary value.

    // If the term is equal to the original value,
    // then the term is equal to itself, which is allowed.
    if (term != originalValue && exists) {
      return translator.disallowedWordExists;
    }

    return null;
  }

  /// Dispose of this delegate.
  void dispose() {
    if (_termsController.isClosed) {
      return;
    }

    for (final excludedTerm in _termsController.value) {
      excludedTerm.dispose();
    }

    unawaited(_termsController.close());
  }
}
