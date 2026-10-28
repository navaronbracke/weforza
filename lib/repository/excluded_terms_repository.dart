import 'package:drift/drift.dart';
import 'package:weforza/database/database.dart';

class ExcludedTermsRepository {
  new(this._database);

  /// The database instance.
  final WeForzaDatabase _database;

  /// Read the excluded terms.
  Future<Set<ExcludedTerm>> read() async {
    final List<ExcludedTerm> excludedTerms = await _database.excludedTerms.select().get();

    return excludedTerms.toSet();
  }

  Future<void> write(Set<ExcludedTerm> excludedTerms) {
    return _database.transaction(() async {
      final existingTermsAsList = await _database.excludedTerms.select().get();
      final existingTerms = {...existingTermsAsList};

      final termsToAdd = excludedTerms.difference(existingTerms);
      final termsToDelete = existingTerms.difference(excludedTerms).map((t) => t.term);

      if (termsToAdd.isEmpty && termsToDelete.isEmpty) {
        return;
      }

      await _database.batch((batch) {
        batch.deleteWhere(_database.excludedTerms, (t) => t.term.isIn(termsToDelete));
        batch.insertAll(_database.excludedTerms, termsToAdd, onConflict: DoNothing());
      });
    });
  }
}
