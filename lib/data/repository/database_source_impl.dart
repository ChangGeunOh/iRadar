import '../../domain/repository/database_source.dart';
import '../database/local_database.dart';

class DatabaseSourceImpl extends DatabaseSource {
  final LocalDatabase _database;

  DatabaseSourceImpl({
    required LocalDatabase database,
  }) : _database = database;

}
