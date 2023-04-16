import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo/services/post.dart';
import 'package:todo/widgets/drawer.dart';

import '../services/sqflite_db.dart';
import '../widgets/todo_item.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  // String title;
  // String type;
  // TodoListScreen({super.key, required this.title, required this.type});
  static const routeName = 'todos';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String token = '';
  getTok() async {
    await getTokenFromDatabase().then((value) => token = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      key: _scaffoldKey,
      body: FutureBuilder(
          future: getTodo(
              token == '' ? '1535a77ca400e1f7ec6cbdc7d3a95fd0658c49c9' : token),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.hasData
                    ? CustomScrollView(
                        slivers: [
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
                                              print(
                                                  snapshot.data![index]['id']);
                                              deleteTodo(
                                                '1',
                                                token,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  leading: Checkbox(
                                    value: snapshot.data![index]['important'],
                                    onChanged: (value) {
                                      value = true;
                                    },
                                  ),
                                  title: Text(snapshot.data![index]['title']),
                                ),
                                // TodoItem(
                                //   isDone: false,
                                //   title: snapshot.data![index]['title'],
                                //   description: DateTime.now().toString(),
                                // ),
                              ),
                              childCount: snapshot.data!.length,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(snapshot.error.toString()),
                      );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(AddTodoScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
