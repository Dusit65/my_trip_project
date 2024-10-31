// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class User {
  String? message;
  String? userId;
  String? username;
  String? password;
  String? email;

  User({
    this.message,
    this.userId,
    this.username,
    this.password,
    this.email,
  });

//Convert JSON file to App data
  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['userId'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
  }
//Convert App data to JSON file
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    return data;
  }
}
