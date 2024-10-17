import 'package:sqflite/sqflite.dart';

import 'helper.dart';

class Category {
  int? id;
  String name;

  Category(this.name, {this.id});

  Map<String, Object?> get toMap {
    var map = <String, Object?>{'name': name};

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Category.fromMap(Map<dynamic, dynamic> map) {
    return Category(
      map['name'],
      id: map['id'],
    );
  }
}

class CategoryProvider {
  late Database db;

  static const String tableName = 'category';
  static const Map<String, List<String>> columns = {
    'id': ['integer', 'primary key', 'autoincrement'],
    'name': ['text', 'not null']
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

  Future<Category> insert(Category category) async {
    category.id = await db.insert(tableName, category.toMap);
    return category;
  }

  Future<Category?> getTodo(int id) async {
    List<Map> maps = await db.query(
      tableName,
      columns: columns.keys.toList(),
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Category.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Category category) async {
    return await db.update(
      tableName,
      category.toMap,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future close() async => db.close();
}
