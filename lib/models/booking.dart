class OfficeReservation {
  final int? id;
  final String? status;
  final Tenant? tenant;
  final Office? office;

  OfficeReservation({
    this.id,
    this.status,
    this.tenant,
    this.office,
  });

  factory OfficeReservation.fromJson(Map<String, dynamic> json) {
    return OfficeReservation(
      id: json['id'],
      status: json['status'],
      tenant: Tenant.fromJson(json['tenant']),
      office: Office.fromJson(json['office']),
    );
  }
}

class Tenant {
  final int? id;
  final int? user;
  final String? email;
  final String? name;

  Tenant({
    this.id,
    this.user,
    this.email,
    this.name,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      user: json['user'],
      email: json['email'],
      name: json['name'],
    );
  }
}

class Office {
  final int? id;
  final String? name;
  final String? landload;
  final String? location;
  final String? picture;
  final int? price;
  final int? size;
  final bool? isAvailable;

  Office({
    this.id,
    this.name,
    this.landload,
    this.location,
    this.picture,
    this.price,
    this.size,
    this.isAvailable,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'],
      name: json['name'],
      landload: json['landload'],
      location: json['location'],
      picture: json['picture'],
      price: json['price'],
      size: json['size'],
      isAvailable: json['is_available'],
    );
  }
}
