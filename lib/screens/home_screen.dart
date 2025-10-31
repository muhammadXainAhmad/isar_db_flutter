import 'package:flutter/material.dart';
import 'package:isar_db/models/enums.dart';
import 'package:isar_db/utils/colors.dart';
import 'package:isar_db/widgets/text.dart';
import 'package:isar_db/widgets/tile_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addOrEdit() {
    TextEditingController contentController = TextEditingController();
    Status status = Status.pending;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: BuildText(
            text: "Add Task",
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
              onPressed: () {},
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
      appBar: AppBar(backgroundColor: whiteClr),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blackClr,
        onPressed: _addOrEdit,
        child: Icon(Icons.add, color: whiteClr),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
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
                    text: "To-Do ${index + 1}",
                    textClr: blackClr,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TileButton(bgClr: blueClr, btnIcon: Icon(Icons.edit)),
                      TileButton(bgClr: redClr, btnIcon: Icon(Icons.delete)),
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
