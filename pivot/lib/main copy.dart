import 'package:flutter/material.dart';
import 'package:pivot/pivot_table_widgert.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flexible Pivot Table with Totals'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> allFields = [
    'region',
    'products',
    'quarter',
    'age',
    'gender',
    'name',
    'profit'
  ];
  List<String> rowFields = [];
  List<String> columnFields = [];
  void changeField(data, List<String> type) {
    if (rowFields.contains(data))
      rowFields.remove(data);
    else if (columnFields.contains(data))
      columnFields.remove(data);
    else if (allFields.contains(data)) allFields.remove(data);
    if (!type.contains(data)) {
      type.add(data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DragTarget(
            onAccept: (data) {
              changeField(data, allFields);
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: EdgeInsets.only(left: 150),
                width: double.infinity,
                height: 80,
                color: Colors.grey,
                padding: EdgeInsets.only(left: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 0,
                      child: Text(
                        "Fields",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                    ),
                    Row(
                      children: [
                        ...allFields.map((e) {
                          return Draggable(
                            data: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ItemDrag(text: e),
                            ),
                            feedback: Material(child: ItemDrag(text: e)),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          DragTarget(
            onAccept: (data) {
              print(data);
              setState(() {
                changeField(data, columnFields);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                margin: EdgeInsets.only(left: 150),
                width: double.infinity,
                height: 80,
                color: Colors.blue,
                padding: EdgeInsets.only(left: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 0,
                      child: Text(
                        "Columns",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                    ),
                    Row(
                      children: [
                        ...columnFields.map((e) {
                          return Draggable(
                            data: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ItemDrag(text: e),
                            ),
                            feedback: Material(child: ItemDrag(text: e)),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DragTarget(
                onAccept: (data) {
                  changeField(data, rowFields);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 150,
                    height: 500,
                    color: Colors.green,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            "Rows",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                        ),
                        Column(
                          children: [
                            ...rowFields.map((e) {
                              return Draggable(
                                data: e,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ItemDrag(text: e),
                                ),
                                feedback: Material(child: ItemDrag(text: e)),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Flexible(
                child: PivotTableWidget(
                  jsonString: '''
                             [
                              {"name": "Alice", "age": 30, "gender": "Female", "region": "North", "sales": 150, "cost": 100, "profit": 50, "products": "Electronics", "quarter": "Q1"},
                              {"name": "Bob", "age": 25, "gender": "Male", "region": "South", "sales": 200, "cost": 120, "profit": 80, "products": "Clothing", "quarter": "Q2"},
                              {"name": "Charlie", "age": 30, "gender": "Male", "region": "North", "sales": 100, "cost": 70, "profit": 30, "products": "Electronics", "quarter": "Q1"},
                              {"name": "David", "age": 25, "gender": "Male", "region": "West", "sales": 120, "cost": 80, "profit": 40, "products": "Furniture", "quarter": "Q3"},
                              {"name": "Eve", "age": 30, "gender": "Female", "region": "South", "sales": 300, "cost": 180, "profit": 120, "products": "Clothing", "quarter": "Q2"},
                              {"name": "Fay", "age": 25, "gender": "Female", "region": "West", "sales": 180, "cost": 100, "profit": 80, "products": "Electronics", "quarter": "Q3"},
                              {"name": "Grace", "age": 25, "gender": "Female", "region": "South", "sales": 170, "cost": 90, "profit": 80, "products": "Furniture", "quarter": "Q1"},
                              {"name": "Henry", "age": 28, "gender": "Male", "region": "East", "sales": 250, "cost": 150, "profit": 100, "products": "Groceries", "quarter": "Q2"},
                              {"name": "Isabella", "age": 27, "gender": "Female", "region": "West", "sales": 190, "cost": 110, "profit": 80, "products": "Clothing", "quarter": "Q3"},
                              {"name": "Jack", "age": 35, "gender": "Male", "region": "North", "sales": 300, "cost": 200, "profit": 100, "products": "Electronics", "quarter": "Q4"},
                              {"name": "Kathy", "age": 32, "gender": "Female", "region": "South", "sales": 120, "cost": 70, "profit": 50, "products": "Furniture", "quarter": "Q4"},
                              {"name": "Leo", "age": 29, "gender": "Male", "region": "East", "sales": 220, "cost": 130, "profit": 90, "products": "Groceries", "quarter": "Q1"},
                              {"name": "Mona", "age": 26, "gender": "Female", "region": "West", "sales": 160, "cost": 90, "profit": 70, "products": "Electronics", "quarter": "Q2"}
      ]
      
                              ''',
                  rowFields: rowFields,
                  columnFields: columnFields,
                  valueFields: ['profit'],
                  valueAggregator: sumAggregator,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  int countAggregator(List<dynamic> values) {
    return values.length; // Count the number of occurrences
  }

  // Sum Aggregator Function
  int sumAggregator(List<dynamic> values) {
    return values.fold(0, (sum, item) => sum + (item is int ? item : 0));
  }
}

class ItemDrag extends StatelessWidget {
  final String text;
  const ItemDrag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.black)),
      child: Text(text),
    );
  }
}
