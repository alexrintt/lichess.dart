import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

String compressJsonIntoSingleLine(String decompressed) {
  return jsonEncode(jsonDecode(decompressed));
}

int random(int lower, int upper) {
  if (lower == upper) {
    return upper;
  }

  lower = min(lower, upper);
  upper = max(lower, upper);

  return Random().nextInt(upper - lower) + lower;
}

List<List<T>> sliceRandomly<T>(List<T> source, int baseSize) {
  final List<List<T>> sliced = <List<T>>[];

  while (source.isNotEmpty) {
    final int size = min(source.length, random(1, baseSize));

    sliced.add(source.sublist(0, size));

    source = source.sublist(size);
  }

  return sliced;
}

Stream<Uint8List> createSimulatedNdjsonUsingMockDir(
  String directoryPath,
) async* {
  final Directory parent = Directory(directoryPath);

  final StringBuffer buffer = StringBuffer();

  // Load all responses at once, and merge by using a new line.
  for (final FileSystemEntity entity in parent.listSync()) {
    if (entity is File && entity.path.endsWith('.json')) {
      buffer.write(compressJsonIntoSingleLine(entity.readAsStringSync()));
    }
    buffer.write('\n');
  }

  // Then split all using random chunks sizes (1-5) and emit each chunk individually.
  // This simulates an HTTP ndjson response:
  // - Emit partial objects.
  // - Emit objects as raw bytes.
  for (final List<int> chunk
      in sliceRandomly<int>(utf8.encode(buffer.toString()), 5)) {
    yield Uint8List.fromList(chunk);
  }
}
