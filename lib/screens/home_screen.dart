import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar_db/models/enums.dart';
import 'package:isar_db/models/todo.dart';
import 'package:isar_db/services/database_service.dart';
import 'package:isar_db/utils/colors.dart';
import 'package:isar_db/widgets/text.dart';
import 'package:isar_db/widgets/tile_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> todos = [];
  StreamSubscription? todosStream;
  @override
  void initState() {
    super.initState();
    // DatabaseService.db.todos.getAll();
    // STREAM
    todosStream = DatabaseService.db.todos
        .buildQuery<Todo>()
        .watch(fireImmediately: true)
        .listen((data) {
          setState(() {
            todos = data;
          });
        });
  }

  @override
  void dispose() {
    todosStream?.cancel();
    super.dispose();
  }

  void _addOrEdit({Todo? todo}) {
    TextEditingController contentController = TextEditingController(
      text: todo?.content ?? "",
    );
    Status status = todo?.status ?? Status.pending;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: BuildText(
            text: todo != null ? "Edit Task" : "Add Task",
            textClr: blackClr,
            textSize: 22,
            textWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 55,
                child: TextField(
                  controller: contentController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "Content",
                    labelStyle: TextStyle(color: blackClr),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: blackClr),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: blackClr),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 55,
                child: DropdownButtonFormField<Status>(
                  borderRadius: BorderRadius.circular(10),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: blackClr),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: blackClr),
                    ),
                  ),
                  value: status,
                  items:
                      Status.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    status = value;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: BuildText(
                text: "Cancel",
                textClr: blackClr,
                textSize: 14,
                textWeight: FontWeight.w400,
              ),
            ),
            TextButton(
              onPressed: () async {
                if (contentController.text.isNotEmpty) {
                  late Todo newTodo;
                  if (todo != null) {
                    newTodo = todo.copyWith(contentController.text, status);
                  } else {
                    newTodo = Todo().copyWith(contentController.text, status);
                  }
                  await DatabaseService.db.writeTxn(() async {
                    await DatabaseService.db.todos.put(newTodo);
                  });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: BuildText(
                text: "Save",
                textClr: blackClr,
                textSize: 14,
                textWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteClr,
      appBar: AppBar(
        backgroundColor: whiteClr,
        title: Text("ISAR DB"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blackClr,
        onPressed: _addOrEdit,
        child: Icon(Icons.add, color: whiteClr),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Card(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12, right: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: greyClr,
                  title: BuildText(
                    text: todo.content!,
                    textClr: blackClr,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                  subtitle: BuildText(
                    text:
                        "Marked ${todo.status.name.toUpperCase()} at ${todo.updatedAt.year}-${todo.updatedAt.month}-${todo.updatedAt.day} \n${todo.updatedAt.hour}:${todo.updatedAt.minute}:${todo.updatedAt.second}",
                    textClr: blackClr,
                    textSize: 14,
                    textWeight: FontWeight.w400,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TileButton(
                        bgClr: blueClr,
                        btnIcon: Icon(Icons.edit),
                        onPressed: () async {
                          _addOrEdit(todo: todo);
                        },
                      ),
                      TileButton(
                        bgClr: redClr,
                        btnIcon: Icon(Icons.delete),
                        onPressed: () async {
                          await DatabaseService.db.writeTxn(() async {
                            await DatabaseService.db.todos.delete(todo.id);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
