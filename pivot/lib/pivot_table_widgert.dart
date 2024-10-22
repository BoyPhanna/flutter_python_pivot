import 'dart:convert';
import 'package:flutter/material.dart';

class PivotTableWidget extends StatelessWidget {
  final String jsonString;
  final List<String> rowFields; // Fields to group by in rows
  final List<String> columnFields; // Fields to group by in columns
  final List<String>
      valueFields; // Fields to aggregate (e.g., 'sales', 'cost', 'profit')
  final Function(List<dynamic>)
      valueAggregator; // Aggregator function (e.g., sum, count, concatenate)

  PivotTableWidget({
    required this.jsonString,
    required this.rowFields,
    required this.columnFields,
    required this.valueFields,
    required this.valueAggregator,
  });

  @override
  Widget build(BuildContext context) {
    // Decode JSON to List of Maps
    List<dynamic> dataList = jsonDecode(jsonString);

    // Helper function to generate keys based on dynamic fields
    String generateKey(Map<String, dynamic> item, List<String> fields) {
      return fields.map((field) => item[field].toString()).join(' / ');
    }

    // Define column categories
    Set<String> columnKeysSet = {};
    Map<String, Map<String, List<dynamic>>> pivotTable = {};

    // Fill the pivot table
    for (var item in dataList) {
      String rowKey = generateKey(item, rowFields);
      String columnKey = generateKey(item, columnFields);

      columnKeysSet.add(columnKey); // Collect unique column keys

      pivotTable.putIfAbsent(rowKey, () => {});
      pivotTable[rowKey]!.putIfAbsent(columnKey, () => []);

      for (var valueField in valueFields) {
        pivotTable[rowKey]![columnKey]!.add(item[valueField]);
      }
    }

    List<String> columnKeys = columnKeysSet.toList()..sort();

    // Initialize column totals and grand total
    Map<String, dynamic> columnTotals = {for (var key in columnKeys) key: 0};
    dynamic grandTotal = 0;

    // Create table header
    List<TableRow> tableRows = [];

    // Header row: first cell empty, then dynamic column categories, then 'Total' column
    tableRows.add(
      TableRow(
        children: [
          TableCell(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    rowFields.join(' / '),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
          ...columnKeys.map((col) => TableCell(
              child: Padding(padding: EdgeInsets.all(8), child: Text(col)))),
          TableCell(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)))),
        ],
      ),
    );

    // Add data rows with totals
    pivotTable.forEach((rowKey, columnValues) {
      dynamic rowTotal = '0';

      tableRows.add(
        TableRow(
          children: [
            TableCell(
                child:
                    Padding(padding: EdgeInsets.all(8), child: Text(rowKey))),
            ...columnKeys.map((colKey) {
              var values = columnValues[colKey] ?? [];
              var value = valueAggregator(values);
              rowTotal = (rowTotal is String)
                  ? (int.parse(rowTotal) + int.parse(value.toString()))
                      .toString()
                  : value;
              columnTotals[colKey] =
                  (columnTotals[colKey] ?? 0) + (value is int ? value : 0);
              grandTotal = (grandTotal is int)
                  ? grandTotal + (value is int ? value : 0)
                  : grandTotal;

              return TableCell(
                  child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(value.toString())));
            }).toList(),
            // Row total
            TableCell(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(rowTotal.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)))),
          ],
        ),
      );
    });

    // Add column totals row
    tableRows.add(
      TableRow(
        children: [
          TableCell(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)))),

          ...columnKeys.map((colKey) => TableCell(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(columnTotals[colKey]?.toString() ?? '0',
                      style: TextStyle(fontWeight: FontWeight.bold))))),
          // Grand total
          TableCell(
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(grandTotal.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)))),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(),
        children: tableRows,
      ),
    );
  }
}
