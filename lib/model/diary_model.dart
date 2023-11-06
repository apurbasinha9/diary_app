import 'package:hive/hive.dart';

part 'diary_model.g.dart';

@HiveType(typeId: 0)
class DiaryModel {
  @HiveField(0)
  String date;

  @HiveField(1)
  String description;

  @HiveField(2)
  int rating;

  DiaryModel(
    this.date,
    this.description,
    this.rating,
  );
}
