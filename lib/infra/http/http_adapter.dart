import 'dart:convert';

import 'package:http/http.dart';
import 'package:main_app/data/http/http.dart';

class HttpAdapter implements MyHttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map<dynamic, dynamic>> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final uri = Uri.parse(url);
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(uri, headers: headers, body: jsonBody);
    // return response.body.isEmpty ? {} : jsonDecode(response.body);
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    final statusCode = response.statusCode;
    if (statusCode == 200) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (statusCode == 204) {
      return {};
    } else if (statusCode == 400) {
      throw HttpError.badRequest;
    } else {
      throw HttpError.serverError;
    }
  }
}
