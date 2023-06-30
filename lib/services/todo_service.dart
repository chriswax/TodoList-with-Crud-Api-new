import 'dart:convert';

import 'package:http/http.dart' as http;

//handles all the API related calls
class TodoService {
  static Future<bool> deleteById(String id) async {
    final url = 'http://chriswax.somee.com/api/TodoList/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> getTodoList() async {
    final url = 'http://chriswax.somee.com/api/TodoList';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final fetchedResult = jsonDecode(response.body) as List;
      return fetchedResult;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(String id, Map body) async {
    final url = 'http://chriswax.somee.com/api/TodoList/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> markTodo(String id, Map body) async {
    final url = 'http://chriswax.somee.com/api/TodoList/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> createTodo(Map body) async {
    final url = 'http://chriswax.somee.com/api/TodoList';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }
}
