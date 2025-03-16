import 'package:confetti/confetti.dart';
import 'package:do_it/common_widgets/customButton.dart';
import 'package:do_it/common_widgets/inputBox.dart';
import 'package:do_it/common_widgets/scaffold_messenger.dart';
import 'package:do_it/models/todo_model.dart';
import 'package:do_it/utils/ui.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoViewmodel extends ChangeNotifier {
  late Box<TodoModel> todoBox;
  int _nextId = 0;
  bool _isLoading = false;
  bool isConfettiPlaying = false;
  final confettiController = ConfettiController();

  List<TodoModel> _todoList = [];

  List<TodoModel> get getTodoList => _todoList;
  bool get isLoading => _isLoading;

  TodoViewmodel() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _isLoading = true;
    notifyListeners();

    todoBox = await Hive.openBox<TodoModel>("todoBox");
    _todoList = todoBox.values.toList();

    _isLoading = false;
    notifyListeners();
  }

  void addTodo(String todoContent) {
    var newTodo = TodoModel(id: _nextId++, content: todoContent);
    todoBox.put(newTodo.id, newTodo);
    _todoList.add(newTodo);
    notifyListeners();
    checkAllTasksCompleted();
  }

  void toggleTaskStatus(int id) {
    final task = todoBox.get(id);
    if (task != null) {
      task.toggleStatus();
      notifyListeners();
      checkAllTasksCompleted();
    }
  }

  void updateTask(int id, String newContent) {
    final todo = todoBox.get(id);
    if (todo != null) {
      todo.content = newContent;
      todoBox.put(todo.id, todo);
      notifyListeners();
    }
  }

  void deleteTodo(int id) {
    todoBox.delete(id);
    _todoList.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void deleteAllTodo() {
    todoBox.clear();
    _todoList = [];
    notifyListeners();
  }

bool verifyIfAllTasksAreCompleted() {
  return _todoList.every((task) => task.isCompleted);
}

void checkAllTasksCompleted() {
  bool check = verifyIfAllTasksAreCompleted();
  
  if (check && !isConfettiPlaying) {
    isConfettiPlaying = true;
    confettiController.play();
    
    Future.delayed(Duration(seconds: 2), () {
      confettiController.stop();
      isConfettiPlaying = false;
    });
    
  }
}

  void showAddTaskModal(
      BuildContext context, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Let's create a new task !",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),
                InputBox(
                    controller: controller,
                    label: "New task ♡",
                    hintText: "What do you wanna do ?",
                    obscureText: false,
                ),
                const SizedBox(height: 50),
                CustomButton(
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        Navigator.pop(context);
                        CustomSnackBar.show(
                            context, "Your task is empty (ó﹏ò｡)", pink);
                        notifyListeners();
                      } else {
                        addTodo(controller.text);
                        Navigator.pop(context);
                        controller.clear();
                        notifyListeners();
                      }
                    },
                    text: "Create ♡",
                    myColor: pink,
                    width: 200),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  void showModifyTaskModal(
      BuildContext context, TextEditingController controller, int id, String oldContent) {
      controller.text = oldContent;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "What changes do you want to make ?",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),
                InputBox(
                    controller: controller,
                    label: "Updating a task ♡",
                    hintText: "Update your task here !",
                    obscureText: false),
                const SizedBox(height: 50),
                CustomButton(
                    onPressed: () {
                      if (controller.text.isEmpty || controller.text == oldContent) {
                        CustomSnackBar.show(context,
                            "You clicked for what ? Nothing ! ( ¬_¬) ", pink);
                        Navigator.pop(context);
                        notifyListeners();
                      } else {
                        updateTask(id, controller.text);
                        Navigator.pop(context);
                        controller.clear();
                        notifyListeners();
                      }
                    },
                    text: "Update ♡",
                    myColor: pink,
                    width: 200),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
