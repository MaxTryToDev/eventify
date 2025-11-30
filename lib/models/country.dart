class Country {
  final String code;
  final String name;
  final double latitude;
  final double longitude;

  Country({required this.code, required this.name, required this.latitude, required this.longitude});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => '$name ($code)';
}