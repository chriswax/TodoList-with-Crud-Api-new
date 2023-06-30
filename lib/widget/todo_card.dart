import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateToEdit;
  final Function(String) deleteById;
  final Function(String) markAsDone;

  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateToEdit,
    required this.deleteById,
    required this.markAsDone,
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
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          icon: Icon(Icons.more, color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
                .copyWith(topRight: Radius.circular(0)),
          ),
          padding: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.grey.shade100,
          onSelected: (value) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('$value item pressed')));
            if (value == 'mark') {
              markAsDone(id);
            } else if (value == 'edit') {
              navigateToEdit(item);
            } else if (value == 'delete') {
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 'mark',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_box,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Mark as Done',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 'edit',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.edit_square,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(right: 50, left: 20),
                value: 'delete',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
