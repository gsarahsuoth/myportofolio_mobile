import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    this.thumbnail = '',
    required this.startMonth,
    required this.startYear,
    this.endMonth = '',
    this.endYear = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String description;
  final String category;
  @JsonKey(defaultValue: '')
  final String thumbnail;
  final String startMonth;
  final String startYear;
  @JsonKey(defaultValue: '')
  final String endMonth;
  @JsonKey(defaultValue: '')
  final String endYear;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
