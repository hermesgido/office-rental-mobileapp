class Office {
  String? id;
  String? name;
  String? description;
  String? picture;
  String? location;
  int? price;
  int? size;
  bool? isAvailable;

  Office({
    this.id,
    this.name,
    this.description,
    this.picture,
    this.location,
    this.price,
    this.size,
    this.isAvailable,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json["id"].toString(),
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      price: json['price'],
      size: json['size'],
      location: json['location'],
      isAvailable: json['is_available'],
    );
  }
}
