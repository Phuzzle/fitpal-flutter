class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
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
