import 'package:dio/dio.dart';

import '../utils.dart';

ResponseBody createResponse() {
  return ResponseBody(
    createSimulatedNdjsonUsingMockDir('test/responses/streamIncomingEvents'),
    200,
  );
}
