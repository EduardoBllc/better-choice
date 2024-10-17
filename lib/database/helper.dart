String getColumnsDeclaration(Map<String, List<String>> columns) {
  List<String> listedColumnsDeclaration = [];

  for (String columnName in columns.keys) {
    List<String>? columnParams = columns[columnName];
    if (columnParams == null) continue;

    String columnParamsDefinition = columnParams.join(' ');
    String columnDeclaration = '$columnName $columnParamsDefinition';
    listedColumnsDeclaration.add(columnDeclaration);
  }

  return listedColumnsDeclaration.join('\n');
}

String getTableDeclaration(
  String tableName,
  Map<String, List<String>> columns,
) {
  return '''
      create table $tableName (
      ${getColumnsDeclaration(columns)}
      )
      ''';
}
