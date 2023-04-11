import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../utils.dart';

ResponseBody createResponse() {
  Stream<Uint8List> generate() async* {
    final Directory parent = Directory('test/responses/streamBoardGameState');

    final StringBuffer buffer = StringBuffer();

    for (final FileSystemEntity entity in parent.listSync()) {
      if (entity is File && entity.path.endsWith('.json')) {
        buffer.write(compressJsonIntoSingleLine(entity.readAsStringSync()));
      }
      buffer.write('\n');
    }

    for (final List<int> chunk
        in sliceRandomly<int>(utf8.encode(buffer.toString()), 5)) {
      yield Uint8List.fromList(chunk);
    }
  }

  return ResponseBody(generate(), 200);
}
