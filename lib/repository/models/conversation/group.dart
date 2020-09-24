import 'package:xopa_app/repository/models/serializable.dart';

class Group extends Serializable<Group> {
    List<String> ids;

    Group({this.ids});

    @override
    Map<String, dynamic> toJson() {
      return {
        'ids': ids,
      };
    }

    @override
    Group fromJson(Map<String, dynamic> json) {
      ids = json['ids'];
      return this;
    }

}