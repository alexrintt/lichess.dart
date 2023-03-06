import './challenge_request.dart';
import '../../common/api_client.dart';
import '../../constants.dart';
import '../../extensions/future_result.dart';

class ChallengeRepository {
  const ChallengeRepository({
    required this.apiClient,
  });

  final ApiClient apiClient;

  FutureResult<void> challenge(String username, ChallengeRequest req) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/challenge/$username'),
      body: req.toRequestBody,
    );
  }

  FutureResult<void> challengeAI(AiChallengeRequest req) {
    return apiClient.post(
      Uri.parse('$kLichessHost/api/challenge/ai'),
      body: req.toRequestBody,
    );
  }

  void dispose() {
    apiClient.close();
  }
}
