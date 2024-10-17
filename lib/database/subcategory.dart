import 'package:sqflite/sqflite.dart';

import 'helper.dart';

class Subcategory {
  int? id;
  String name;
  int categoryId;

  Subcategory(this.name, this.categoryId, {this.id});

  Map<String, Object?> get toMap {
    var map = <String, Object?>{
      'name': name,
      'category_id': categoryId,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Subcategory.fromMap(Map<dynamic, dynamic> map) {
    return Subcategory(
      id: map['id'],
      map['name'],
      map['category_id'],
    );
  }
}

class CategoryProvider {
  late Database db;

  static const String tableName = 'category';
  static const Map<String, List<String>> columns = {
    'id': ['integer', 'primary key', 'autoincrement'],
    'name': ['text', 'not null'],
    'category_id': ['integer', 'not null']
  };

  Future open(String path) async {
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(getTableDeclaration(tableName, columns));
      },
    );
  }

  Future<Subcategory> insert(Subcategory category) async {
    category.id = await db.insert(tableName, category.toMap);
    return category;
  }

  Future<Subcategory?> getTodo(int id) async {
    List<Map> maps = await db.query(
      tableName,
      columns: columns.keys.toList(),
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Subcategory.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Subcategory category) async {
    return await db.update(
      tableName,
      category.toMap,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future close() async => db.close();
}
