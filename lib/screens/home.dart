import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_kids/blocs/counter_bloc.dart';
import 'package:only_kids/widgets/bottom_nav_bar.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final CounterBloc _counter = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Air it',
            onPressed: () {},
          ),
        ],
      ),
      body: MyBody(counter: _counter),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _counter.dispatch(CounterEvent.increment);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class MyBody extends StatelessWidget {
  const MyBody({
    Key key,
    @required CounterBloc counter,
  })  : _counter = counter,
        super(key: key);

  final CounterBloc _counter;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: BlocBuilder(
          bloc: _counter,
          builder: (BuildContext context, int count) {
            return Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                    // color: Theme.of(context).canvasColor,
                    ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text('Services'),
                      ),
                      ListTile(
                        title: Text('Our Team'),
                      ),
                      ListTile(
                        title: Text('About Us'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
