abstract class Api{
  // static const String siteRoot = "192.168.0.10:8000";
  static const String siteRoot = "127.0.0.1:8000";

  String get apiEndpoint;

  String apiPath() => apiEndpoint;
}