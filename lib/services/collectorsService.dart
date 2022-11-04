import 'dart:convert';
import '../main.dart';
import '../models/collector.dart';
import 'package:http/http.dart' as http;

class CollectorsService {
  static Future<List<Collector>> getCollectors() async {
    String getCollectorUrl = MyApp().url + "/getCollectors.php";

    final response = await http.get(Uri.parse(getCollectorUrl));
    final body = json.decode(response.body);
    return List.from(body.map<Collector>(Collector.fromJson).toList());
  }
}