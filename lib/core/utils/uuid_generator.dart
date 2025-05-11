import 'package:uuid/uuid.dart';

abstract class UuidGenerator {
  String generate();
}

class UuidV4Generator implements UuidGenerator {
  final Uuid _uuid = Uuid();

  @override
  String generate() {
    return _uuid.v4();
  }
}