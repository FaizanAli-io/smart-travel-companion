import 'package:http/http.dart' as http;
import 'package:flutter_project/data/sample_places.dart';

Future<void> main() async {
  for (var place in samplePlaces) {
    try {
      final response = await http.get(Uri.parse(place.imageUrl));
      if (response.statusCode == 404) {
        print('❌ 404 BROKEN: ${place.name} -> ${place.imageUrl}');
      }
    } catch (e) {
      print('⚠️ ERROR connecting to ${place.imageUrl}');
    }
  }
}
