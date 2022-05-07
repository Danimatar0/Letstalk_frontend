import 'dart:convert';

class Preference {
  int id;
  String cuisineName;
  String cuisineCountry;
  Preference({
    required this.id,
    required this.cuisineName,
    required this.cuisineCountry,
  });

  Preference copyWith({
    int? id,
    String? cuisineName,
    String? cuisineCountry,
  }) {
    return Preference(
      id: id ?? this.id,
      cuisineName: cuisineName ?? this.cuisineName,
      cuisineCountry: cuisineCountry ?? this.cuisineCountry,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cuisineName': cuisineName,
      'cuisineCountry': cuisineCountry,
    };
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    return Preference(
      id: map['id']?.toInt() ?? 0,
      cuisineName: map['cuisineName'] ?? '',
      cuisineCountry: map['cuisineCountry'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Preference.fromJson(String source) =>
      Preference.fromMap(json.decode(source));

  @override
  String toString() =>
      'Preference(id: $id, cuisineName: $cuisineName, cuisineCountry: $cuisineCountry)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Preference &&
        other.id == id &&
        other.cuisineName == cuisineName &&
        other.cuisineCountry == cuisineCountry;
  }

  @override
  int get hashCode =>
      id.hashCode ^ cuisineName.hashCode ^ cuisineCountry.hashCode;
}
