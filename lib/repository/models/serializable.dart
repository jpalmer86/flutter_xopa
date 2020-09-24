import 'dart:convert';

typedef S SerializableCreator<S>();

abstract class Serializable<T> {
  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

T jsonDecode<T extends Serializable<T>>(
    SerializableCreator<T> creator, dynamic responseData) {
  if(responseData is Map<String, dynamic>) {
    return creator().fromJson(responseData);
  }
  final decodedJson = json.decode(responseData);
  return decodedJson == null ? null : creator().fromJson(decodedJson);
}

List<T> jsonDecodeList<T extends Serializable<T>>(
    SerializableCreator<T> creator, dynamic responseData) {
  if(responseData == null) {
    return null;
  }
  if(responseData is List<dynamic>) {
    return responseData.map((json) => creator().fromJson(json)).toList();
  }
  return List.from(json.decode(responseData) ?? [])
      .map((json) => creator().fromJson(json))
      .toList();
}
