abstract class MyHttpClient {
  Future<Map> request({
    required String url,
    required String method,
    Map body,
  });
}
