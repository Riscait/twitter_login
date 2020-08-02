import 'package:http/http.dart' as http;
import 'package:twitter_login/src/signature.dart';
import 'package:twitter_login/src/utils.dart';

/// http client
class HttpClient {
  /// send mothod
  static Future<Map<String, dynamic>> send(
    String url,
    Map<String, dynamic> params,
    String apiKey,
    String apiSecretKey,
  ) async {
    try {
      final _signature = Signature(
        url: url,
        method: 'POST',
        params: params,
        apiKey: apiKey,
        apiSecretKey: apiSecretKey,
        tokenSecretKey: '',
      );
      params['oauth_signature'] = _signature.signatureHmacSha1(
        _signature.getSignatureKey(),
        _signature.signatureDate(),
      );
      final hedaer = authHeader(params);
      final http.BaseClient _httpClient = http.Client();
      final http.Response res = await _httpClient.post(
        url,
        headers: <String, String>{'Authorization': hedaer},
      );
      if (res.statusCode != 200) {
        throw Exception("Failed ${res.reasonPhrase}");
      }

      return Uri.splitQueryString(res.body);
    } on Exception catch (error) {
      throw Exception(error.toString());
    }
  }
}
