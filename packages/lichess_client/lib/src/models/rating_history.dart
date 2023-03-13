import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_history.g.dart';
part 'rating_history.freezed.dart';

typedef _SortingFunction<T> = int Function(T a, T z);

/// This class generate useful info from the raw rating [points] provided by the Lichess API.
///
/// Since this is not something that is not something that differs
/// from implementations, it is included in this core library.
class RatingHistoryInfo {
  const RatingHistoryInfo(this.points);

  final List<List<int>> points;

  /// Whether or not the [points] are following the pattern defined by the Lichess API.
  ///
  /// The pattern is a list of length 4: `[int, int, int, int]`.
  ///
  /// This though does not validates if the provided date or rating.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
  bool get isValid => points.every((List<int> point) => point.length == 4);

  bool get isEmpty => points.isEmpty;

  /// Alias for [parseRawPointsAsRatingHistoryEntries].
  ///
  /// The [points] are parsed but not sorted.
  List<RatingHistoryEntry> get entries =>
      parseRawPointsAsRatingHistoryEntries();

  /// Alias for [parseRawPointsAsRatingHistoryEntries].
  ///
  /// The [points] are parsed and sorted by date using descending order.
  List<RatingHistoryEntry> get entriesByDateDescending => sortedBy();

  /// Alias for [parseRawPointsAsRatingHistoryEntries].
  ///
  /// The [points] are parsed and sorted by rating using descending order.
  List<RatingHistoryEntry> get entriesByRatingDescending =>
      sortedBy(field: RatingHistorySortField.rating);

  /// Alias for [parseRawPointsAsRatingHistoryEntries].
  ///
  /// The [points] are parsed and sorted by rating using ascending order.
  List<RatingHistoryEntry> get entriesByRatingAscending => sortedBy(
        direction: SortDirection.ascending,
        field: RatingHistorySortField.rating,
      );

  /// Alias for [parseRawPointsAsRatingHistoryEntries].
  ///
  /// The [points] are parsed and sorted by rating using ascending order.
  List<RatingHistoryEntry> get entriesByDateAscending =>
      sortedBy(direction: SortDirection.ascending);

  /// Return the entry with the highest rating.
  ///
  /// Throws [StateError] if [points] is empty.
  RatingHistoryEntry get highest {
    if (isEmpty) {
      throw StateError('No element');
    }

    return entriesByRatingDescending.first;
  }

  /// Return the highest rating present in this history.
  ///
  /// Throws [StateError] if [points] is empty.
  int get highestRating {
    if (isEmpty) {
      throw StateError('No element');
    }

    return highest.rating;
  }

  /// Return the entry with the lowest rating.
  ///
  /// Throws [StateError] if [points] is empty.
  RatingHistoryEntry get lowest {
    if (isEmpty) {
      throw StateError('No element');
    }

    return entriesByRatingDescending.last;
  }

  /// Return the lowest rating present in this history.
  ///
  /// Throws [StateError] if [points] is empty.
  int get lowestRating {
    if (isEmpty) {
      throw StateError('No element');
    }

    return lowest.rating;
  }

  /// Return the most recent entry present in this history.
  ///
  /// Throws [StateError] if [points] is empty.
  RatingHistoryEntry get newest {
    if (isEmpty) {
      throw StateError('No element');
    }

    return entriesByDateDescending.first;
  }

  /// Return the most recent [DateTime] present in this history.
  ///
  /// Throws [StateError] if [points] is empty.
  DateTime get newestDate {
    if (isEmpty) {
      throw StateError('No element');
    }

    return newest.date;
  }

  /// Return the oldest entry present in this history.
  ///
  /// Throws [StateError] if [points] is empty.
  RatingHistoryEntry get oldest {
    if (isEmpty) {
      throw StateError('No element');
    }

    return entriesByDateDescending.last;
  }

  /// Return the oldest [DateTime] present in this history.
  ///
  /// Throws [StateError] if [points] is empty.
  DateTime get oldestDate {
    if (isEmpty) {
      throw StateError('No element');
    }

    return oldest.date;
  }

  /// The [RatingHistory] of user consists in a array of [points] that per se is already
  /// a [List] that represents the user rating at a point in the time.
  ///
  /// This function parses the each point `List<int>` to a data class that holds
  /// a [DateTime] and a [rating] following the Lichess API reference.
  ///
  /// Throws [StateError] if [points] is null.
  ///
  /// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
  List<RatingHistoryEntry> parseRawPointsAsRatingHistoryEntries() {
    return points.map((List<int> point) {
      final int year = point[0];
      final int month = point[1];
      final int day = point[2];
      final int rating = point[3];

      return RatingHistoryEntry(
        date: DateTime.utc(year, month + 1, day),
        rating: rating,
      );
    }).toList();
  }

  List<RatingHistoryEntry> sortedBy({
    RatingHistorySortField field = RatingHistorySortField.date,
    SortDirection direction = SortDirection.descending,
  }) =>
      parseRawPointsAsRatingHistoryEntries()
        ..sort(
          _generateSortFnAccording(
            direction: direction,
            field: field,
          ),
        );

  _SortingFunction<RatingHistoryEntry> _generateSortFnAccording({
    RatingHistorySortField field = RatingHistorySortField.date,
    SortDirection direction = SortDirection.descending,
  }) {
    double getItemValueUsingRequestedField(RatingHistoryEntry entry) {
      switch (field) {
        case RatingHistorySortField.date:
          return entry.date.millisecondsSinceEpoch.toDouble();
        case RatingHistorySortField.rating:
          return entry.rating.toDouble();
      }
    }

    // TODO: Refactor to use tuples when Dart 3 is stable.
    List<RatingHistoryEntry> getItemsUsingRequestedDirection(
      List<RatingHistoryEntry> originalOrder,
    ) {
      final RatingHistoryEntry a = originalOrder.first;
      final RatingHistoryEntry z = originalOrder.last;

      switch (direction) {
        case SortDirection.ascending:
          return <RatingHistoryEntry>[a, z];
        case SortDirection.descending:
          return <RatingHistoryEntry>[z, a];
      }
    }

    int sortBy(RatingHistoryEntry a, RatingHistoryEntry z) {
      final Iterable<double> values =
          getItemsUsingRequestedDirection(<RatingHistoryEntry>[a, z])
              .map(getItemValueUsingRequestedField);

      return values.first.compareTo(values.last);
    }

    return sortBy;
  }
}

/// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
@freezed
class RatingHistory with _$RatingHistory {
  const factory RatingHistory({
    String? name,
    List<List<int>>? points,
  }) = _RatingHistory;

  /// https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models.
  const RatingHistory._();

  factory RatingHistory.fromJson(Map<String, dynamic> json) =>
      _$RatingHistoryFromJson(json);

  RatingHistoryInfo? get info =>
      points != null ? RatingHistoryInfo(points!) : null;
}

/// Built-in fields supported by [RatingHistoryInfo].
enum RatingHistorySortField {
  date,
  rating,
}

/// A general sorting direction enum class.
enum SortDirection {
  /// For dates means the most recent to older.
  descending,

  /// For dates means the order to most recent.
  ascending,
}

/// A typed entry that represents a point provided by the Lichess API user rating history.
///
/// https://lichess.org/api#tag/Users/operation/apiUserRatingHistory
@freezed
class RatingHistoryEntry with _$RatingHistoryEntry {
  const factory RatingHistoryEntry({
    required DateTime date,
    required int rating,
  }) = _RatingHistoryEntry;

  factory RatingHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$RatingHistoryEntryFromJson(json);
}
