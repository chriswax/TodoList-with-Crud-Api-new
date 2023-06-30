import 'package:flutter/material.dart';
import 'package:todo_list_ui_api/provider/provider.dart';
import 'package:todo_list_ui_api/screens/todo_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          //title: 'Theme Switcher',
          theme: themeModel.currentTheme,
          home: TodoListPage(),
        ),
      ),
    );
  }
}
