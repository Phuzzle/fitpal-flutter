import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String muscleGroup;

  @HiveField(3)
  final bool isBodyWeight;

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.isBodyWeight,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup,
      'isBodyWeight': isBodyWeight,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      muscleGroup: json['muscleGroup'],
      isBodyWeight: json['isBodyWeight'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.muscleGroup == muscleGroup &&
        other.isBodyWeight == isBodyWeight;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ muscleGroup.hashCode ^ isBodyWeight.hashCode;
}
