import 'dart:convert';
import 'dart:io';

/// Utilities for manipulating JSON
class JsonUtils {

  /// Load a JSON file from file system and convert it to a Map
  ///
  /// @param path The file path for the file containing a JSON object
  /// @return Map<String, dynamic> representing the JSON object5
  static Map<String, dynamic> loadJsonFromFile(String path) {
    File jsonFile = File(path);
    String fileContents = jsonFile.readAsStringSync();
    Map<String, dynamic> jsonMap = json.decode(fileContents);
    return jsonMap;
  }
}