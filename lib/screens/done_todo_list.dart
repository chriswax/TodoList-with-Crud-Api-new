import 'package:flutter/material.dart';
import 'package:todo_list_ui_api/screens/todo_list.dart';
import 'package:todo_list_ui_api/services/todo_service.dart';
import 'package:todo_list_ui_api/widget/todo_card_done.dart';

import '../utils/snackbar_helper.dart';

class DoneTodoListPage extends StatefulWidget {
  const DoneTodoListPage({super.key});

  @override
  State<DoneTodoListPage> createState() => _DoneTodoListPageState();
}

class _DoneTodoListPageState extends State<DoneTodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    getTodoList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Todo List Page'),
        leading: IconButton(
          onPressed: navigateToTodoListPage,
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),

      //display the fetched items
      body: Visibility(
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
                'No Marked Todo Item Found!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(left: 8, right: 8, top: 20),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                //final id = item['id'] as String;

                return TodoCardDone(
                  index: index,
                  item: item,
                  deleteByDoneId: deleteByDoneId,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteByDoneId(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      getTodoList();
      final filteredItem = items
          .where((element) => element['id'] != id && element['isDone'] == false)
          .toList();
      setState(() {
        items = filteredItem;
      });
      showSuccessMsg(context, message: "Delete done Todo List");
    } else {
      showErrorMsg(context, message: "Failed to Delete! ");
    }
  }

  Future<void> getTodoList() async {
    final response = await TodoService.getTodoList();
    if (response != null) {
      final result = response.where((item) => item['isDone'] == true).toList();
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

  void navigateToTodoListPage() {
    final route = MaterialPageRoute(
      builder: (context) => TodoListPage(),
    );
    Navigator.push(context, route);
  }
}
