import 'dart:convert';

typedef JsonMap = Map<String, dynamic>;


abstract class TypedSegment {
  factory TypedSegment.fromJson(JsonMap json) =>
      json['runtimeType'] == 'CreateSegment'
          ? CreateSegment(uuid: json['uuid'])
          : TodosSegment();

  JsonMap toJson() => <String, dynamic>{'runtimeType': runtimeType.toString()};
  @override
  String toString() => jsonEncode(toJson());
}

typedef TypedPath = List<TypedSegment>;

class TodosSegment with TypedSegment {}

class CreateSegment with TypedSegment {
  CreateSegment({this.uuid});
  final String? uuid;
  @override
  JsonMap toJson() => super.toJson()..['uuid'] = uuid;
}
