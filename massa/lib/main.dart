import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Person {
  String name;
  double height;
  double weight;

  Person({required this.name, required this.height, required this.weight});

  double calculateBMI() {
    return weight / (height * height);
  }
}

class PersonList with ChangeNotifier {
  List<Person> _persons = [];

  List<Person> get persons => _persons;

  void addPerson(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  void editPerson(int index, Person person) {
    _persons[index] = person;
    notifyListeners();
  }

  void deletePerson(int index) {
    _persons.removeAt(index);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => PersonList(),
        child: PersonListView(),
      ),
    );
  }
}

class PersonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMC Calculator'),
      ),
      body: Consumer<PersonList>(
        builder: (context, personList, child) {
          return ListView.builder(
            itemCount: personList.persons.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(personList.persons[index].name),
                subtitle: Text(
                    'BMI: ${personList.persons[index].calculateBMI().toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonDetailsView(index),
                    ),
                  );
                },
                onLongPress: () {
                  personList.deletePerson(index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonAddView(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PersonDetailsView extends StatefulWidget {
  final int index;

  PersonDetailsView(this.index);

  @override
  _PersonDetailsViewState createState() => _PersonDetailsViewState();
}

class _PersonDetailsViewState extends State<PersonDetailsView> {
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final person =
        Provider.of<PersonList>(context, listen: false).persons[widget.index];
    _nameController.text = person.name;
    _heightController.text = person.height.toString();
    _weightController.text = person.weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text;
                    final height = double.parse(_heightController.text);
                    final weight = double.parse(_weightController.text);
                    final person =
                        Person(name: name, height: height, weight: weight);

                    Provider.of<PersonList>(context, listen: false)
                        .editPerson(widget.index, person);
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PersonAddView extends StatefulWidget {
  @override
  _PersonAddViewState createState() => _PersonAddViewState();
}

class _PersonAddViewState extends State<PersonAddView> {
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Person'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final height = double.parse(_heightController.text);
                final weight = double.parse(_weightController.text);
                final person =
                    Person(name: name, height: height, weight: weight);

                Provider.of<PersonList>(context, listen: false)
                    .addPerson(person);
                Navigator.pop(context);
              },
              child: Text('Add Person'),
            ),
          ],
        ),
      ),
    );
  }
}
