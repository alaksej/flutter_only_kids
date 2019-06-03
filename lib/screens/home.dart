import 'package:flutter/material.dart';
import 'package:only_kids/services/counter.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: StreamBuilder(
          stream: counterService.stream$,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: counterService.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
