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
    final counterBloc = CounterBloc();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => counterBloc,
          lazy: true,
        ),
        BlocProvider(
          create: (context) => UserBloc(counterBloc),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = context.read<CounterBloc>();

    return Scaffold(
      floatingActionButton: BlocConsumer<CounterBloc, int>(
        listenWhen: (previous, current) => previous > current,
        listener: (context, state) {
          if (state == 0) {
            Scaffold.of(context).showBottomSheet(
                    (context) => Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 30,
                  child: Text('State is 0'),
                )
            );
          }
        },
        builder: (context, state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.toString()),
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
                  // Navigator.push(context,
                  //     MaterialPageRoute(
                  //       builder: (_) => Job(userBloc: userBloc),
                  //       )
                  //     )
                  // );

                  // Navigator.push(context,
                  //     MaterialPageRoute(
                  //       builder: (_) => BlocProvider.value(
                  //         value: userBloc,
                  //         child: Job(),
                  //       )
                  //     )
                  // );

                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => Job()
                      )
                  );
                  userBloc.add(UserGetUsersJobEvent(counterBloc.state));
                },
                icon: Icon(Icons.work)
            )
          ],
        ),
      ),

      // floatingActionButton: BlocListener<CounterBloc, int>(
      //   listenWhen: (previous, current) => previous > current,
      //   listener: (context, state) {
      //     if (state == 0) {
      //       Scaffold.of(context).showBottomSheet(
      //               (context) => Container(
      //             color: Colors.blue,
      //             width: double.infinity,
      //             height: 30,
      //             child: Text('State is 0'),
      //           )
      //       );
      //     }
      //   },
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       IconButton(
      //           onPressed: () {
      //             // final counterBloc = BlocProvider.of<CounterBloc>(context);
      //             counterBloc.add(CounterIncEvent());
      //           },
      //           icon: Icon(Icons.plus_one)
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             final counterBloc = context.read<CounterBloc>();
      //             counterBloc.add(CounterDecEvent());
      //           },
      //           icon: Icon(Icons.exposure_minus_1)
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             final userBloc = context.read<UserBloc>();
      //             final counterBloc = context.read<CounterBloc>();
      //             userBloc.add(UserGetUsersEvent(counterBloc.state));
      //           },
      //           icon: Icon(Icons.person)
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             final userBloc = context.read<UserBloc>();
      //             final counterBloc = context.read<CounterBloc>();
      //             // Navigator.push(context,
      //             //     MaterialPageRoute(
      //             //       builder: (_) => Job(userBloc: userBloc),
      //             //       )
      //             //     )
      //             // );
      //
      //             // Navigator.push(context,
      //             //     MaterialPageRoute(
      //             //       builder: (_) => BlocProvider.value(
      //             //         value: userBloc,
      //             //         child: Job(),
      //             //       )
      //             //     )
      //             // );
      //
      //             Navigator.push(context,
      //                 MaterialPageRoute(
      //                     builder: (_) => Job()
      //                 )
      //             );
      //             userBloc.add(UserGetUsersJobEvent(counterBloc.state));
      //           },
      //           icon: Icon(Icons.work)
      //       )
      //     ],
      //   ),
      // ),
      
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              BlocBuilder<CounterBloc, int>(
                // bloc: counterBloc,
                builder: (context, state) {
                  // final bloc = context.watch<UserBloc>();
                  final users = context.select((UserBloc bloc) =>
                  bloc.state.users);

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
            ],
          ),
        ),
      ),
    );
  }
}

class Job extends StatelessWidget {
  // final UserBloc userBloc;

  // const Job({Key? key, required this.userBloc}) : super(key: key);
  const Job({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
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
    );
  }
}
