import 'package:flutter/material.dart';

class TodoCardDone extends StatelessWidget {
  final int index;
  final Map item;
  final Function(String) deleteByDoneId;

  const TodoCardDone({
    super.key,
    required this.index,
    required this.item,
    required this.deleteByDoneId,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['id'] as String;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(
          item['title'],
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          item['description'],
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
            size: 30,
          ),
          onPressed: () {
            deleteByDoneId(id);
          },
        ),
      ),
    );
  }
}
