import 'package:bloc_project/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CounterBloc();

    return BlocProvider<CounterBloc>(
      create: (context) => bloc,
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  bloc.add(CounterIncEvent());
                },
                icon: Icon(Icons.plus_one)
            ),
            IconButton(
                onPressed: () {
                  bloc.add(CounterDecEvent());
                },
                icon: Icon(Icons.exposure_minus_1)
            )
          ],
        ),
        body: Center(
          child: BlocBuilder<CounterBloc, int>(
            bloc: bloc,
            builder: (context, state) {
              return Text(state.toString(),
                style: TextStyle(fontSize: 33),
              );
            },
          ),
        ),
      )
    );
  }
}

