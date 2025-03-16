import 'package:do_it/common_widgets/customButton.dart';
import 'package:do_it/common_widgets/inputBox.dart';
import 'package:do_it/utils/ui.dart';
import 'package:flutter/material.dart';

void showAddTaskModal(BuildContext context, TextEditingController controller) {
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
                    label: "New note ♡",
                    hintText: "What do you wanna do ?",
                    obscureText: false),
                const SizedBox(height: 50),
                CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "Create ♡",
                    myColor: pastelPink,
                    width: 200),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  void showModifyTaskModal(BuildContext context, TextEditingController controller) {
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
                  "What changes do you want to make !",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),
                InputBox(
                    controller: controller,
                    label: "Updating a note ♡",
                    hintText: "Update your note here !",
                    obscureText: false),
                const SizedBox(height: 50),
                CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "Update ♡",
                    myColor: pastelPink,
                    width: 200),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
  