class Plant {
  final String id;
  final String name;
  final String? nickname;
  final String location;
  final String image;
  final String status;
  final int? waterDays;
  final bool isFavorite;
  final DateTime? lastWatered;
  final int? wateringIntervalDays;
  final String? light;
  final String? temperature;
  final String? humidity;
  final int? ageMonths;

  Plant({
    required this.id,
    required this.name,
    this.nickname,
    required this.location,
    required this.image,
    required this.status,
    this.waterDays,
    this.isFavorite = false,
    this.lastWatered,
    this.wateringIntervalDays,
    this.light,
    this.temperature,
    this.humidity,
    this.ageMonths,
  });

  int get daysUntilWatering {
    if (lastWatered == null || wateringIntervalDays == null) return 0;
    final nextWatering = lastWatered!.add(
      Duration(days: wateringIntervalDays!),
    );
    return nextWatering.difference(DateTime.now()).inDays;
  }

  int get daysSinceLastWatered {
    if (lastWatered == null) return 0;
    return DateTime.now().difference(lastWatered!).inDays;
  }

  String get statusText {
    switch (status) {
      case 'needs_water':
        return 'Perlu Disiram';
      case 'healthy':
        return 'Sehat';
      case 'attention':
        return 'Perlu Perhatian';
      default:
        return status;
    }
  }

  Plant copyWith({
    String? id,
    String? name,
    String? nickname,
    String? location,
    String? image,
    String? status,
    int? waterDays,
    bool? isFavorite,
    DateTime? lastWatered,
    int? wateringIntervalDays,
    String? light,
    String? temperature,
    String? humidity,
    int? ageMonths,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      location: location ?? this.location,
      image: image ?? this.image,
      status: status ?? this.status,
      waterDays: waterDays ?? this.waterDays,
      isFavorite: isFavorite ?? this.isFavorite,
      lastWatered: lastWatered ?? this.lastWatered,
      wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
      light: light ?? this.light,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      ageMonths: ageMonths ?? this.ageMonths,
    );
  }
}
