import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_ui_api/screens/add_update_todo_list.dart';
import 'package:todo_list_ui_api/screens/done_todo_list.dart';
import 'package:todo_list_ui_api/services/todo_service.dart';
import 'package:todo_list_ui_api/widget/todo_card.dart';

import '../provider/provider.dart';
import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  // bool isTheme = true;
  List items = [];

  @override
  void initState() {
    getTodoList();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Todo App'),
        leading: IconButton(
          tooltip: "Navigate to Marked as done Todo Lists",
          icon: Icon(
            Icons.view_list_sharp,
            size: 30,
          ),
          onPressed: navigateToMarkedList,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Todo App'),
            Container(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/waec.jpeg'),
              ),
            )
          ],
        ),
      ),

      //display the fetched items
      body: Container(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 14, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: navigateToMarkedList,
                            child: Text(
                              'View Done Todo List',
                              style: TextStyle(
                                color: Colors.blue,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final themeModel = Provider.of<ThemeModel>(
                                  context,
                                  listen: false);
                              themeModel.toggleTheme();
                            },
                            child: Text(
                              'Tap to change Theme',
                              style: TextStyle(
                                color: Colors.blue,
                                //decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blueAccent)),
                      child: TextField(
                        onChanged: (value) => _runFilter(value),
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 20,
                          ),
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 20,
                            minWidth: 25,
                          ),
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                        //color: Colors.blue,
                        ),
                    Text(
                      'All Todos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: isLoading,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                replacement: RefreshIndicator(
                  onRefresh: getTodoList,
                  child: Visibility(
                    //shows no item or all
                    visible: items.isNotEmpty,
                    replacement: Center(
                      child: Text(
                        'No Todo Item Found!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: items.length,
                      padding: EdgeInsets.all(4),
                      itemBuilder: (context, index) {
                        final item = items[index] as Map;
                        //final id = item['id'] as String;

                        return TodoCard(
                          index: index,
                          item: item,
                          navigateToEdit: navigateToEditPage,
                          deleteById: deleteById,
                          markAsDone: markAsDone,
                        );
                        //if statement for isDone
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: navigateToCreatePage,
        // child: Text("Add Todo"),
        child: const Icon(
          Icons.add,
          size: 40,
          weight: 20,
        ),
      ),
    );
  }

  Future<void> navigateToCreatePage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddUpdateTodoListPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getTodoList();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddUpdateTodoListPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getTodoList();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filteredItem = items
          .where((element) => element['id'] != id && element['isDone'] == false)
          .toList();
      setState(() {
        items = filteredItem;
      });
    } else {
      showErrorMsg(context, message: "Failed to Delete! ");
    }
  }

  Future<void> markAsDone(String id) async {
    final getItem = items.where((element) => element['id'] == id).toList();
    final title = getItem[0]["title"] as String;
    final description = getItem[0]["description"] as String;

    final body = {
      "title": title,
      "description": description,
      "isDone": true,
    };

    final isSuccess = await TodoService.markTodo(id, body);
    if (isSuccess) {
      final filteredItem = items
          .where((element) => element['id'] != id && element['isDone'] == false)
          .toList();
      setState(() {
        items = filteredItem;
      });
      showSuccessMsg(context, message: "Marked as done Successfully");
    } else {
      showErrorMsg(context, message: "Failed to Mark!");
    }
  }

  Future<void> getTodoList() async {
    final response = await TodoService.getTodoList();
    if (response != null) {
      final result = response.where((item) => item['isDone'] == false).toList();
      setState(() {
        items = result;
      });
    } else {
      showErrorMsg(context, message: "error!, Something went wrong");
    }
    setState(() {
      isLoading = false;
    });
  }

//search for items

  void _runFilter(String enteredKeyword) {
    List _foundTodo = [];
    if (enteredKeyword.isEmpty) {
      getTodoList();
      _foundTodo = items;
    } else {
      _foundTodo = items
          .where((element) => element['title']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      items = _foundTodo;
    });
  }

  void navigateToTodoListPage() {
    final route = MaterialPageRoute(
      builder: (context) => TodoListPage(),
    );
    Navigator.push(context, route);
  }

  void navigateToMarkedList() {
    final route = MaterialPageRoute(
      builder: (context) => DoneTodoListPage(),
    );
    Navigator.push(context, route);
  }
}
