class VenueModel {
  List<Venue>? venues;

  VenueModel({this.venues});

  VenueModel.fromJson(Map<String, dynamic> json) {
    if (json['venues'] != null) {
      venues = <Venue>[];
      json['venues'].forEach((v) {
        venues!.add(new Venue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.venues != null) {
      data['venues'] = this.venues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Venue {
  String? address;
  String? phoneNo;
  List<Seats>? seats;
  String? urlPhoto;
  int? venueColumnLength;
  int? venueId;
  String? venueName;
  int? venueRowLength;
  int? venueSectionCount;

  Venue(
      {this.address,
      this.phoneNo,
      this.seats,
      this.urlPhoto,
      this.venueColumnLength,
      this.venueId,
      this.venueName,
      this.venueRowLength,
      this.venueSectionCount});

  Venue.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    phoneNo = json['phone_no'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(new Seats.fromJson(v));
      });
    }
    urlPhoto = json['url_photo'];
    venueColumnLength = json['venue_column_length'];
    venueId = json['venue_id'];
    venueName = json['venue_name'];
    venueRowLength = json['venue_row_length'];
    venueSectionCount = json['venue_section_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['phone_no'] = this.phoneNo;
    if (this.seats != null) {
      data['seats'] = this.seats!.map((v) => v.toJson()).toList();
    }
    data['url_photo'] = this.urlPhoto;
    data['venue_column_length'] = this.venueColumnLength;
    data['venue_id'] = this.venueId;
    data['venue_name'] = this.venueName;
    data['venue_row_length'] = this.venueRowLength;
    data['venue_section_count'] = this.venueSectionCount;
    return data;
  }
}

class Seats {
  String? seatPosition;
  int? venueId;

  Seats({this.seatPosition, this.venueId});

  Seats.fromJson(Map<String, dynamic> json) {
    seatPosition = json['seat_position'];
    venueId = json['venue_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['seat_position'] = seatPosition;
    data['venue_id'] = this.venueId;
    return data;
  }
}
