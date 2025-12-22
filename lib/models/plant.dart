class Plant {
  final String name;
  final String location;
  final String image;
  final String status; // 'needs_water', 'healthy', 'attention'
  final int? waterDays;

  Plant({
    required this.name,
    required this.location,
    required this.image,
    required this.status,
    this.waterDays,
  });
}
