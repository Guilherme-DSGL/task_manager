import 'package:flutter/foundation.dart';

import '../../../domain/entities/todo_item.dart';

class TodoScreenViewModel extends ChangeNotifier {
  List<TodoItem> todoItems = [
    const TodoItem(
      title: "Design sign up flow",
      description:
          "By the time a prospect arrives at your signup page, in most cases, they've already By the time a prospect arrives at your signup page, in most cases.",
      isCompleted: false,
    )
  ];

  TodoItem getTodo(int index) => todoItems[index];

  void _load() async {
    try {} finally {
      notifyListeners();
    }
  }
}
