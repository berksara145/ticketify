class EventModel {
  String? descriptionText;
  String? endDate;
  String? eventCategory;
  int? eventId;
  String? eventName;
  String? eventRules;
  String? organizerFirstName;
  String? organizerLastName;
  String? performerName;
  String? startDate;
  String? ticketPrices;
  String? urlPhoto;
  EventVenue? venue;

  EventModel(
      {this.descriptionText,
      this.endDate,
      this.eventCategory,
      this.eventId,
      this.eventName,
      this.eventRules,
      this.organizerFirstName,
      this.organizerLastName,
      this.performerName,
      this.startDate,
      this.ticketPrices,
      this.urlPhoto,
      this.venue});

  EventModel.fromJson(Map<String, dynamic> json) {
    descriptionText = json['description_text'];
    endDate = json['end_date'];
    eventCategory = json['event_category'];
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventRules = json['event_rules'];
    organizerFirstName = json['organizer_first_name'];
    organizerLastName = json['organizer_last_name'];
    performerName = json['performer_name'];
    startDate = json['start_date'];
    ticketPrices = json['ticket_prices'];
    urlPhoto = json['url_photo'];
    venue =
        json['venue'] != null ? new EventVenue.fromJson(json['venue']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description_text'] = this.descriptionText;
    data['end_date'] = this.endDate;
    data['event_category'] = this.eventCategory;
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_rules'] = this.eventRules;
    data['organizer_first_name'] = this.organizerFirstName;
    data['organizer_last_name'] = this.organizerLastName;
    data['performer_name'] = this.performerName;
    data['start_date'] = this.startDate;
    data['ticket_prices'] = this.ticketPrices;
    data['url_photo'] = this.urlPhoto;
    if (this.venue != null) {
      data['venue'] = this.venue!.toJson();
    }
    return data;
  }
}

class EventVenue {
  String? address;
  String? urlPhoto;
  String? venueName;

  EventVenue({this.address, this.urlPhoto, this.venueName});

  EventVenue.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    urlPhoto = json['url_photo'];
    venueName = json['venue_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['url_photo'] = this.urlPhoto;
    data['venue_name'] = this.venueName;
    return data;
  }
}
