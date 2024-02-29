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
    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await client.post(uri, headers: headers, body: jsonBody);
      }
    } catch (erro) {
      throw HttpError.serverError;
    }

    // return response.body.isEmpty ? {} : jsonDecode(response.body);
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    // final statusCode = response.statusCode;
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else if (response.statusCode == 500) {
      throw HttpError.serverError;
    } else {
      throw HttpError.serverError;
    }
  }
}
