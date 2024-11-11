class Trip {
  String? message;
  String? trip_id;
  String? user_id;
  String? startDate;
  String? endDate;
  String? locationName;
  String? latitude;
  String? longitude;
  String? cost;
  String? tripImage;
  String? tripImage2;
  String? tripImage3;


  Trip(
      {this.message,
      this.trip_id,
      this.user_id,
      this.startDate,
      this.endDate,
      this.locationName,
      this.latitude,
      this.longitude,
      this.cost,
      this.tripImage,
      this.tripImage2,
      this.tripImage3
      });
//Convert JSON file to App data
  Trip.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trip_id = json['trip_id'];
    user_id = json['user_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    locationName = json['location_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    cost = json['cost'];
    tripImage = json['tripImage'];
    tripImage2 = json['tripImage2'];
    tripImage3 = json['tripImage3'];
  }
//Convert App data to JSON file
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['trip_id'] = this.trip_id;
    data['user_id'] = this.user_id;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['location_name'] = this.locationName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['cost'] = this.cost;
    data['tripImage'] = this.tripImage;
    data['tripImage2'] = this.tripImage2;
    data['tripImage3'] = this.tripImage3;
    return data;
  }
}
//changeto .dart
