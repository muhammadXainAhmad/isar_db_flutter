import 'package:isar/isar.dart';
import 'package:isar_db/models/enums.dart';

// execute command: flutter pub run build_runner build
part 'todo.g.dart';

@Collection() // COLLECTIONS CAN'T HAVE CONSTRUCTORS ASSOCIATED WITH THEM
class Todo {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? content;

  bool isDone = false;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  @enumerated
  Status status = Status.pending;

  Todo copyWith(String? content, Status? status) {
    return Todo()
      ..id = id
      ..createdAt = createdAt
      ..updatedAt = DateTime.now()
      ..content = content ?? this.content
      ..status = status ?? this.status;
  }
}
