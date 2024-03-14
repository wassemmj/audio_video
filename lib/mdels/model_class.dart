import 'package:hive/hive.dart';

part 'model_class.g.dart';

@HiveType(typeId: 0)
class ModelClass {
  @HiveField(0)
  final String?  uri  ;
  @HiveField(1)
  final String? artist ;
  @HiveField(2)
  final String? name ;
  @HiveField(3)
  final int? duration ;
  @HiveField(4)
  final int? index ;
  @HiveField(5)
  final int? id ;

  ModelClass({required this.uri, required this.artist, required this.name, required this.duration , required this.index , required this.id});



}