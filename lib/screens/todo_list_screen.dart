import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/services/post.dart';
import 'package:todo/widgets/drawer.dart';

import 'add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  String username;
  TodoListScreen({super.key, required this.username});
  static const routeName = 'todos';

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // String token = '';
  @override
  void initState() {
    //  getTokenFromDatabase().then(
    //   (value) {
    //     token = value;
    //   },
    // );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(
          username: widget.username,
        ),
        key: _scaffoldKey,
        body: FutureBuilder(
            future: getTodo(''),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : snapshot.hasData
                      ? CustomScrollView(slivers: [
                          SliverAppBar(
                            leading: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                            title: Text('Todo List'),
                            expandedHeight: 200,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.asset(
                                'assets/images/todo-back.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // SliverToBoxAdapter(
                          //   child: value.todos(),
                          // ),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, index) => Dismissible(
                                key: ValueKey(index),
                                confirmDismiss: (direction) {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            content: const Text(
                                              'Really, Do you want to delete this todo?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    deleteTodo(1, '')
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ]);
                                      });
                                },
                                child: ListTile(
                                  leading: Checkbox(
                                    value: snapshot.data![index]['important'],
                                    onChanged: (value) {
                                      value = true;
                                    },
                                  ),
                                  title: Text(snapshot.data![index]['title']),
                                )
                                // TodoItem(
                                //   isDone: false,
                                //   title: snapshot.data![index]['title'],
                                //   description: DateTime.now().toString(),
                                // ),
                                ),
                            childCount: snapshot.data!.length,
                          ))
                        ])
                      : Scaffold(
                          body: Center(
                          child: Text(snapshot.error.toString()),
                        ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.goNamed('add-new');
          },
          child: const Icon(Icons.add),
        ));
  }
}
