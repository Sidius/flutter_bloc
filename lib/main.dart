import 'package:bloc_project/counter_bloc.dart';
import 'package:bloc_project/user_bloc/user_bloc.dart';
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
      home: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
      ],
      child: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = context.read<CounterBloc>();
    
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                // final counterBloc = BlocProvider.of<CounterBloc>(context);
                counterBloc.add(CounterIncEvent());
              },
              icon: Icon(Icons.plus_one)
          ),
          IconButton(
              onPressed: () {
                final counterBloc = context.read<CounterBloc>();
                counterBloc.add(CounterDecEvent());
              },
              icon: Icon(Icons.exposure_minus_1)
          ),
          IconButton(
              onPressed: () {
                final userBloc = context.read<UserBloc>();
                final counterBloc = context.read<CounterBloc>();
                userBloc.add(UserGetUsersEvent(counterBloc.state));
              },
              icon: Icon(Icons.person)
          ),
          IconButton(
              onPressed: () {
                final userBloc = context.read<UserBloc>();
                final counterBloc = context.read<CounterBloc>();
                userBloc.add(UserGetUsersJobEvent(counterBloc.state));
              },
              icon: Icon(Icons.work)
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              BlocBuilder<CounterBloc, int>(
                // bloc: counterBloc,
                builder: (context, state) {
                  // final bloc = context.watch<UserBloc>();
                  final users = context.select((UserBloc bloc) => bloc.state.users);

                  return Column(
                    children: [
                      Text(state.toString(),
                        style: TextStyle(fontSize: 33),
                      ),
                      if (users.isNotEmpty)
                        ...users.map((e) =>
                            Text(e.name,
                              style: TextStyle(fontSize: 33),
                            ),
                        ),
                    ],
                  );
                },
              ),
              BlocBuilder<UserBloc, UserState>(
                // bloc: userBloc,
                builder: (context, state) {
                  final users = state.users;
                  final jobs = state.jobs;

                  return Column(
                    children: [
                      if (state.isLoading) CircularProgressIndicator(),

                      if (jobs.isNotEmpty)
                        ...jobs.map((e) =>
                            Text(e.name,
                              style: TextStyle(fontSize: 33),
                            ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

