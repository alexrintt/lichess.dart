import 'dart:convert';
import 'dart:math';

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
