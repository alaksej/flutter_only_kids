import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:only_kids/blocs/counter_bloc.dart';
import 'package:only_kids/screens/about_page.dart';
import 'package:only_kids/screens/services_page.dart';
import 'package:only_kids/screens/team_page.dart';
import 'package:only_kids/widgets/bottom_nav_bar.dart';

import 'book_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

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
      body: _HomeBody(counter: _counter),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => BookPage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ServicesPage()));
                        },
                      ),
                      Divider(
                        height: 1.0,
                      ),
                      ListTile(
                        title: Text('Our Team'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TeamPage()));
                        },
                      ),
                      Divider(
                        height: 1.0,
                      ),
                      ListTile(
                        title: Text('About Us'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AboutPage()));
                        },
                      ),
                      Divider(
                        height: 1.0,
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
