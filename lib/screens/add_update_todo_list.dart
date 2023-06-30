import 'package:flutter/material.dart';
import 'package:todo_list_ui_api/screens/todo_list.dart';
import 'package:todo_list_ui_api/services/todo_service.dart';

import '../utils/snackbar_helper.dart';

class AddUpdateTodoListPage extends StatefulWidget {
  final Map? todo; //variable for the passed todo:item
  const AddUpdateTodoListPage({
    super.key,
    this.todo,
  });

  @override
  State<AddUpdateTodoListPage> createState() => _AddUpdateTodoListPageState();
}

class _AddUpdateTodoListPageState extends State<AddUpdateTodoListPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isUpdate = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Edite Todo' : "Add Todo",
        ),
        leading: IconButton(
          onPressed: navigateToTodoListPage,
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        //Icon(Icons.arrow_back_ios),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Enter Title here',
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white, width: 1),
              // borderRadius: BorderRadius.circular(50),
              //),
            ),
          ),
          SizedBox(height: 22),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Enter Description here',
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.white, width: 1),
              //   borderRadius: BorderRadius.circular(15),
              // ),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 6,
            maxLines: 10,
          ),
          SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: isUpdate ? updateData : submitData,
            icon: Icon(
              isUpdate ? Icons.edit_square : Icons.save_as_outlined,
            ),
            label: Text(
              isUpdate ? 'Update' : "Save",
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('Error occured!, todo data must be called');
      return;
    }

    final id = todo['id'];
    final isDone = todo['isDone'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "isDone": isDone,
    };

    final isSuccess = await TodoService.updateTodo(id, body);
    if (isSuccess) {
      showSuccessMsg(context, message: "Updated Successfully");
    } else {
      showErrorMsg(context, message: "Failed to Update!");
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {"title": title, "description": description};

    final isSuccess = await TodoService.createTodo(body);
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMsg(context, message: "Saved Successfully");
    } else {
      showErrorMsg(context, message: "Failed to save!");
    }
  }

  void navigateToTodoListPage() {
    final route = MaterialPageRoute(
      builder: (context) => TodoListPage(),
    );
    Navigator.push(context, route);
  }

  //refactoring the body
  // Map get body{
  //   final title = titleController.text;
  //   final description = descriptionController.text;
  //   bool isDone = false;
  //   return {
  //     "title": title,
  //     "description": description,
  //     "isDone": isDone,
  //   };
  // }
}
