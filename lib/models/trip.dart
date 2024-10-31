class Trip {
  String? message;
  String? tripId;
  String? userId;
  String? startDate;
  String? endDate;
  String? locationName;
  String? latitude;
  String? longitude;
  String? cost;

  Trip(
      {this.message,
      this.tripId,
      this.userId,
      this.startDate,
      this.endDate,
      this.locationName,
      this.latitude,
      this.longitude,
      this.cost, String? user_id});
//Convert JSON file to App data
  Trip.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    tripId = json['trip_id'];
    userId = json['user_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    locationName = json['location_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cost = json['cost'];
  }
//Convert App data to JSON file
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['trip_id'] = this.tripId;
    data['user_id'] = this.userId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['location_name'] = this.locationName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['cost'] = this.cost;
    return data;
  }
}
//changeto .dart
