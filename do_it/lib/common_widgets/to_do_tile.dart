// ignore_for_file: must_be_immutable
import 'package:do_it/utils/ui.dart';
import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool isTaskComplete;
  Function(bool?)? onChanged;
  Function()? onPressed;

  ToDoTile(
      {super.key,
      required this.taskName,
      required this.isTaskComplete,
      required this.onChanged,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            color: pastelPink, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: ListTile(
            leading: Checkbox(
              value: isTaskComplete,
              onChanged: onChanged,
              activeColor: white,
              checkColor: pastelPink,
            ),
            title: Text(
              taskName,
              style: isTaskComplete
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(fontSize: 17),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.edit_rounded, color: white)),
          ),
        ),
      ),
    );
  }
}
