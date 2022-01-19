import 'package:cars/utils/dbhelper.dart';
import 'package:cars/models/car.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: non_constant_identifier_names
  final DbHelper = DatabaseHelper.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Car> cars = [];
  List<Car> carsByName = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController milesController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController idUpdateController = TextEditingController();
  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController milesUpdateController = TextEditingController();
  TextEditingController idDeleteController = TextEditingController();

  void _showMessageInScaffold(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(
      const SnackBar(
        backgroundColor: Colors.purple,
        content: Text(
          'Successful ✓ ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text("Car App Sqflite"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Insert",
                ),
                Tab(
                  text: "View",
                ),
                Tab(
                  text: "Query",
                ),
                Tab(
                  text: "Update",
                ),
                Tab(
                  text: "Delete",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Car Name'),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: milesController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Car Miles'),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    ElevatedButton(
                      child: const Text("Insert Car Details"),
                      onPressed: () {
                        String name = nameController.text;
                        int miles = int.parse(milesController.text);
                        _insert(name, miles);
                      },
                    )
                  ],
                ),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cars.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == cars.length) {
                        return ElevatedButton(
                            child: const Text("Refresh"),
                            onPressed: () {
                              setState(() {
                                _queryAll();
                              });
                            });
                      }
                      // ignore: sized_box_for_whitespace
                      return Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            "[${cars[index].id}] ${cars[index].name} - ${cars[index].miles} miles",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: queryController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Car Name'),
                        onChanged: (text) {
                          if (text.length >= 2) {
                            setState(() {
                              _query(text);
                            });
                          } else {
                            setState(() {
                              carsByName.clear();
                            });
                          }
                        },
                      ),
                      height: 100,
                    ),
                    Expanded(
                        // ignore: sized_box_for_whitespace
                        child: Container(
                      height: 300,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: carsByName.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              height: 50,
                              margin: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  "[${carsByName[index].id}] ${carsByName[index].name} - ${carsByName[index].miles} miles",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          }),
                    ))
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: idUpdateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Car ID'),
                        onChanged: (text) {
                          if (text.length >= 2) {
                            setState(() {
                              _query(text);
                            });
                          } else {
                            setState(() {
                              carsByName.clear();
                            });
                          }
                        },
                      ),
                      height: 100,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: nameUpdateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Car Name '),
                        onChanged: (text) {
                          if (text.length >= 2) {
                            setState(() {
                              _query(text);
                            });
                          } else {
                            setState(() {
                              carsByName.clear();
                            });
                          }
                        },
                      ),
                      height: 100,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: milesUpdateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Car Miles'),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Update Car Details"),
                      onPressed: () {
                        int id = int.parse(idUpdateController.text);
                        String name = nameUpdateController.text;
                        int miles = int.parse(milesUpdateController.text);
                        _update(id, name, miles);
                      },
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: idDeleteController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Car ID'),
                        onChanged: (text) {
                          if (text.length >= 2) {
                            setState(() {
                              _query(text);
                            });
                          } else {
                            setState(() {
                              carsByName.clear();
                            });
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: const Text("Delete Car Details"),
                      onPressed: () {
                        int id = int.parse(idDeleteController.text);
                        _delete(id);
                      },
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void _insert(String name, int miles) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnMiles: miles,
    };

    Car car = Car.fromMap(row);
    final id = await DbHelper.insert(car);
    _showMessageInScaffold('inserted row id: $id');
  }

  void _queryAll() async {
    final allRows = await DbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((row) => cars.add(Car.fromMap(row)));
    _showMessageInScaffold("Qery done.");
    setState(() {});
  }

  void _query(name) async {
    final allRows = await DbHelper.queryRows(name);
    carsByName.clear();
    allRows.forEach((row) => carsByName.add(Car.fromMap(row)));
  }

  void _update(int id, String name, int miles) async {
    Car car = Car(id, name, miles);
    final rowsAffected = await DbHelper.update(car);
    _showMessageInScaffold("updated $rowsAffected row(s)");
  }

  void _delete(int id) async {
    final rowsDeleted = await DbHelper.delete(id);
    _showMessageInScaffold("deleted $rowsDeleted row(s): rows $id");
  }
}
