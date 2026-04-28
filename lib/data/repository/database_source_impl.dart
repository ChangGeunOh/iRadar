import '../../domain/repository/database_source.dart';
import '../database/local_database.dart';

class DatabaseSourceImpl extends DatabaseSource {
  /// In-memory reference to the underlying database implementation.
  /// Keeping this as a public field avoids unused-field lint and makes it
  /// available for future DatabaseSource APIs.
  final LocalDatabase database;

  DatabaseSourceImpl({
    required this.database,
  });

}
