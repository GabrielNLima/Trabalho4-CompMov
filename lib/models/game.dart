class Carro {
  final String id;
  final String name;
  final String genre;
  final String hours;
  final String rating;
  final DateTime purchaseDate;
  final String? img;
  final String userId;

  Carro({
    required this.id,
    required this.name,
    required this.genre,
    required this.hours,
    required this.rating,
    required this.purchaseDate,
    this.img,
    required this.userId,
  });
}