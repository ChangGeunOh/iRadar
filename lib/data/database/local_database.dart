import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../common/const/database.dart';


class LocalDatabase {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), kDatabaseName);
    return await openDatabase(
      path,
      version: kDatabaseVersion,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          db.rawQuery('drop table $kTableCGV');
          db.rawQuery('drop table $kTableBanner');
          await _onCreate(db, newVersion);
        }
      },
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $kTableCGV (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ranking INTEGER DEFAULT 0,
        movieType TEXT DEFAULT '',
        title TEXT DEFAULT '', 
        imgPoster TEXT DEFAULT '',
        percent REAL DEFAULT 0,
        accumulateCount TEXT DEFAULT '',
        eggState TEXT DEFAULT '', 
        eggPercent TEXT DEFAULT '', 
        screenTypes TEXT DEFAULT '',
        ageGrade TEXT DEFAULT '',
        dDay TEXT DEFAULT '',
        onlyCGV TEXT DEFAULT ''
        )''');

    await db.execute('''CREATE TABLE $kTableBanner (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imgBanner TEXT DEFAULT '', 
        linkBanner TEXT DEFAULT ''
        )''');
  }

/*
  Future<void> saveMovieData(MovieData movieData) async {
    final db = await database;
    final jsonData = movieData.toJson();
    if (movieData.id < 0) {
      jsonData.remove('id');
    }
    await db.insert(
      kTableCGV,
      jsonData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MovieData>> loadMovieList(MovieType movieType) async {
    final db = await database;
    final result = await db.query(
      kTableCGV,
      where: 'movieType = ?',
      whereArgs: [movieType.name],
    );
    final list = result.map((e) => MovieData.fromJson(e));
    return list.toList();
  }


  Future<void> saveBannerData(BannerData bannerData) async {
    final db = await database;
    final jsonData = bannerData.toJson();
    if (bannerData.id < 0) {
      jsonData.remove('id');
    }
    print(bannerData.toJson());
    await db.insert(
      kTableBanner,
      jsonData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BannerData>> loadBannerList() async {
    final db = await database;
    final result = await db.query(kTableBanner);
    final list = result.map((e) => BannerData.fromJson(e));
    return list.toList();
  }
*/

  Future<void> delete(String table) async {
    final db = await database;
    db.delete(table);
  }
}
