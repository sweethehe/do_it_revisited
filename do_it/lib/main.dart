import 'package:do_it/models/todo_model.dart';
import 'package:do_it/view_models/todo_viewModel.dart';
import 'package:do_it/views/todo_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: GoogleFonts.delius().fontFamily,
          ),
      home: ChangeNotifierProvider(
        create: (context) => TodoViewmodel(),
        child: TodoView(),
      )
    );
  }
}
