import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp2());

class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  final Map<String, Map<String, int>> _data = {
    'Settings': {'courses': 1},
    'Grades': {'Mathe': 1, 'Deutsch': 1, 'Informatik': 1}
  };
  void switchCourses() {
    setState(() {
      _data['Settings']['courses'] =
          (0 == _data['Settings']['courses']) ? 1 : 0;
    });
  }

  void addCourse(String courseName, int grade) {
    setState(() {
      _data['Grades'].addAll({courseName: grade});
    });
  }

  void setGrade(String courseName, int grade) {
    setState(() {
      _data['Grades'][courseName] = grade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbiPlanner',
      home: Noten2(_data['Grades'], this),
    );
  }
}

class AddCourseDialog extends StatefulWidget {
  final _parent;
  AddCourseDialog(this._parent);
  @override
  _AddCourseDialogState createState() => _AddCourseDialogState(this._parent);
}

class _AddCourseDialogState extends State<AddCourseDialog> {
  final _parent;
  _AddCourseDialogState(this._parent);
  final myController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: myController,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            _parent.addCourse(myController.text, 1);
            Navigator.pop(context);},
        ),
        FlatButton(
          child: Text('Abbrechen'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

class Noten2 extends StatelessWidget {
  final Map<String, int> _grades;
  final _parent;
  Noten2(this._grades, this._parent);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Notenübersicht'),
            FloatingActionButton(
                onPressed: () {
                  //return AddCourseDialog(this._parent);
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AddCourseDialog(_parent);
                    },
                  );
                },
                tooltip: 'Add new course',
                child: Icon(Icons.add)),
          ],
        ),
      ),
      body: GradeView2(_grades, this._parent),
    );
  }
}

class GradeView2 extends StatelessWidget {
  final Map<String, int> _grades;
  final _MyApp2State _parent;
  GradeView2(this._grades, this._parent);
  //not sure if the following works...
  //Function() incrementGrade(String key) {
  //  return () => _parent.setGrade(key, _grades[key] + 1);
  //}

  @override
  Widget build(BuildContext context) {
    var listElements = <Widget>[];
    void addListElement(String key, int value) {
      listElements.add(MyListTile(key, value, _parent));
    }

    _grades.forEach(addListElement);
    return ListView(children: listElements);
  }
}

class MyListTile extends ListTile {
  MyListTile(subject, grade, parent)
      : super(
          title: Text(subject),
          trailing: Text(grade.toString()),
          onTap: () => parent.setGrade(subject, grade + 1),
        );
}

/*
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abi Planer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Noten(),
    );
  }
}

class Noten extends StatefulWidget {
  @override
  _NotenState createState() => _NotenState();
}

class _NotenState extends State<Noten> {
  var _grades = {'Mathe': 1, 'Deutsch': 1, 'Informatik': 1, 'Englisch' : 1, 'Geschichte' : 500};
  void setGrade(String subject, int grade) {
    setState(() {
      _grades[subject] = grade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notenübersicht'),
      ),
      body: GradeView(_grades, this),
    );
  }
}

class GradeView extends StatelessWidget {
  final _grades;
  final _NotenState _parent;
  GradeView(this._grades, this._parent);
  //not sure if the following works...
  //Function() incrementGrade(String key) {
  //  return () => _parent.setGrade(key, _grades[key] + 1);
  //}

  @override
  Widget build(BuildContext context) {
    var listElements = <Widget>[];
    void addListElement(String key, int value) {
      listElements.add(MyListTile(key, value, _parent));
    }

    _grades.forEach(addListElement);
    return ListView(children: listElements);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
