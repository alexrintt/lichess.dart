import 'dart:convert';
import 'package:logging/logging.dart';
import '../../common/api_client.dart';
import '../../constants.dart';
import './tv_event.dart';

class TvRepository {
  const TvRepository(
    Logger log, {
    required this.apiClient,
  }) : _log = log;

  final ApiClient apiClient;
  final Logger _log;

  Stream<TvEvent> tvFeed() async* {
    final resp = await apiClient.stream(Uri.parse('$kLichessHost/api/tv/feed'));
    _log.fine('Start streaming TV.');
    yield* resp.stream
        .toStringStream()
        .where((event) => event.isNotEmpty && event != '\n')
        .map((event) => jsonDecode(event) as Map<String, dynamic>)
        .where((json) => json['t'] == 'featured' || json['t'] == 'fen')
        .map(TvEvent.fromJson)
        .handleError((Object error) => _log.warning(error));
  }

  void dispose() {
    apiClient.close();
  }
}
