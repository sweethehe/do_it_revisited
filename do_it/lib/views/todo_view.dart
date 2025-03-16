import 'package:confetti/confetti.dart';
import 'package:do_it/common_widgets/navigateToPage.dart';
import 'package:do_it/common_widgets/show_dialog.dart';
import 'package:do_it/common_widgets/to_do_tile.dart';
import 'package:do_it/utils/ui.dart';
import 'package:do_it/view_models/todo_viewModel.dart';
import 'package:do_it/views/about.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  TextEditingController create_controller = TextEditingController();
  TextEditingController update_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    create_controller.dispose();
    update_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todo_viewModel = Provider.of<TodoViewmodel>(context);
    return Stack(children: [
      Scaffold(
        drawer: Drawer(
          child: Column(
          children: [
            DrawerHeader(
                child: Image.asset(
              "assets/images/do_it_logo.png",
            )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Do-it ♡",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  navigateToPage(context, const About());
                },
                child: const ListTile(
                  title: Text(
                    "About",
                    style: TextStyle(fontSize: 20, color: black),
                  ),
                  leading:
                      Icon(Icons.account_circle_rounded, color: black),
                ),
              ),
            )
          ],
        ),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Today's Todo List (˶º⤙º˶)", style: TextStyle(fontSize: 20)),
              IconButton(
                  onPressed: () {
                    buildDialogChoice(
                        context,
                        "Do you really want to delete all your tasks ?",
                        "Yep (ง •̀_•́)ง",
                        "No (•﹏•;)", go: () {
                      todo_viewModel.deleteAllTodo();
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: pink,
                  )),
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: todo_viewModel.isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Loading...",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: pink,
                            strokeWidth: 2,
                          ),
                        ],
                      ),
                    )
                  : todo_viewModel.getTodoList.isEmpty
                      ? const Center(
                          child: Text(
                            "There's no task here yet ! Try adding one. ٩(ˊᗜˋ )و",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: todo_viewModel.getTodoList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                                background: Container(
                                  height: 75,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 114, 104),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                key:
                                    ValueKey(todo_viewModel.getTodoList[index]),
                                onDismissed: (direction) {
                                  todo_viewModel.deleteTodo(
                                      todo_viewModel.getTodoList[index].id);
                                },
                                child: ToDoTile(
                                    taskName: todo_viewModel
                                        .getTodoList[index].content,
                                    isTaskComplete: todo_viewModel
                                        .getTodoList[index].isCompleted,
                                    onChanged: (bool? newValue) =>
                                        todo_viewModel.toggleTaskStatus(
                                            todo_viewModel
                                                .getTodoList[index].id),
                                    onPressed: () {
                                      todo_viewModel.showModifyTaskModal(
                                          context,
                                          update_controller,
                                          todo_viewModel.getTodoList[index].id, 
                                          todo_viewModel.getTodoList[index].content);
                                    }));
                          })),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              todo_viewModel.showAddTaskModal(context, create_controller),
          backgroundColor: const Color(0xFFf8b0d1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      ConfettiWidget(
        confettiController: context.read<TodoViewmodel>().confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 50,
      ),
    ]);
  }
}
