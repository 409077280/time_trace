import 'dart:io';
import 'dart:convert';

class HttpAccess {

  final host = "www.cudag.com";
  final port = 8080;

  Future getResponseBody(HttpClientResponse response) async {
    var responseBody = await response.transform(utf8.decoder).join();
    return responseBody;
  }

  Future Get(String path) async {
    HttpClient httpClient = new HttpClient();
    var request = await httpClient.get(this.host, this.port, path);
    HttpClientResponse response = await request.close();
    return response;
  }

  void GethasToken() {}
}

class SearchUserList extends HttpAccess {

  Future getUserList(String userName) async {
    String path = "getuserlist?username=" + userName;
    var result;
    HttpClientResponse response = await super.Get(path);
    if (response.statusCode == HttpStatus.ok) {
      String responseBody = await super.getResponseBody(response);
      Map data = jsonDecode(responseBody);
      result = {"result": true, "body": data};
    } else {
      result = {"result": false, "body": null};
    }
    return result;
  }

}
