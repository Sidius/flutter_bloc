import 'package:bloc_project/counter_bloc.dart';
import 'package:bloc_project/search_bloc/search_bloc.dart';
import 'package:bloc_project/user_bloc/user_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_user_repository/search_user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Lesson 8
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SearchUserRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchBloc(
              searchUserRepository: RepositoryProvider.of<SearchUserRepository>(context)
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              textTheme: const TextTheme(
                  bodyText1: TextStyle(fontSize: 33),
                  subtitle1: TextStyle(fontSize: 22)
              )
          ),
          home: const Scaffold(
            body: SafeArea(
              child: MyHomePage(),
            ),
          ),
        ),
      ),
    );
  }

// Lesson 7
// @override
// Widget build(BuildContext context) {
//   return MultiBlocProvider(
//     providers: [
//       BlocProvider(
//         create: (context) => SearchBloc(),
//       ),
//     ],
//     child: MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         textTheme: const TextTheme(
//           bodyText1: TextStyle(fontSize: 33),
//           subtitle1: TextStyle(fontSize: 22)
//         )
//       ),
//       home: const Scaffold(
//         body: SafeArea(
//           child: MyHomePage(),
//         ),
//       ),
//     ),
//   );
// }

// @override
// Widget build(BuildContext context) {
//   final counterBloc = CounterBloc();
//
//   return MultiBlocProvider(
//     providers: [
//       BlocProvider(
//         create: (context) => counterBloc,
//         lazy: true,
//       ),
//       BlocProvider(
//         create: (context) => UserBloc(counterBloc),
//       ),
//     ],
//     child: MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     ),
//   );
// }
}

// Lesson 8
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = context.select((SearchBloc bloc) => bloc.state.users);

    return Column(
      children: [
        const Text("Search User"),
        const SizedBox(height: 20,),
        TextFormField(
          decoration: const InputDecoration(
              hintText: "User name",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder()
          ),
          onChanged: (value) {
            context.read<SearchBloc>().add(SearchUserEvent(value));
          },
        ),
        if (users.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final user = users[index];

                print(user.images);

                return ListTile(
                  title: Text(user.username ?? ''),
                  leading: Hero(
                    tag: user.username ?? '',
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.images ?? ''),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => UserInfoScreen(
                          user: user,
                        )
                      )
                    );
                  },
                );
              },
              itemCount: users.length,
            ),
          ),
      ],
    );
  }
}

class UserInfoScreen extends StatelessWidget {
  final UserModel user;

  const UserInfoScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username ?? '',
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ),
      body: Column(
        children: [
          Hero(
            tag: user.username ?? '',
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user.images ?? '')
                )
              ),
            )
          ),
          Text.rich(TextSpan(
            style: TextStyle(
              fontSize: 16
            ),
            children: [
              TextSpan(
                text: 'Visit Site: '
              ),
              TextSpan(
                text: user.url ?? '',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline
                ),
                recognizer: TapGestureRecognizer()..onTap = () {
                  
                }
              ),
            ]
          ))
        ],
      ),
    );
  }
}


// Lesson 7
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final users = context.select((SearchBloc bloc) => bloc.state.users);
//
//     return Column(
//       children: [
//         const Text("Search User"),
//         const SizedBox(height: 20,),
//         TextFormField(
//           decoration: const InputDecoration(
//               hintText: "User name",
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder()
//           ),
//           onChanged: (value) {
//             context.read<SearchBloc>().add(SearchUserEvent(value));
//           },
//         ),
//         if (users.isNotEmpty)
//           Expanded(
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(users[index]['username']),
//                 );
//               },
//               itemCount: users.length,
//             ),
//           ),
//       ],
//     );
//   }
// }

class MyHomePageOld extends StatelessWidget {
  const MyHomePageOld({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = context.read<CounterBloc>();

    return Scaffold(
      floatingActionButton: BlocConsumer<CounterBloc, int>(
        listenWhen: (previous, current) => previous > current,
        listener: (context, state) {
          if (state == 0) {
            Scaffold.of(context).showBottomSheet((context) =>
                Container(
                  color: Colors.blue,
                  width: double.infinity,
                  height: 30,
                  child: Text('State is 0'),
                )
            );
          }
        },
        builder: (context, state) =>
            Column(
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
