class DropOffPoint {
  final String id;
  final String name;
  final String address;
  final String distance;
  final String openingHours;
  final List<String> acceptedCategories;
  final double latitude;
  final double longitude;
  final String contact;

  const DropOffPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.openingHours,
    required this.acceptedCategories,
    required this.latitude,
    required this.longitude,
    required this.contact,
  });
}
