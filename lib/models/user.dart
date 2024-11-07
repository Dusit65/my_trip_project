// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class User {
  String? message;
  String? user_id;
  String? username;
  String? password;
  String? email;
  String? userImage;

  User({
    this.message,
    this.user_id,
    this.username,
    this.password,
    this.email,
    this.userImage,
  });

//Convert JSON file to App data
  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user_id = json['user_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    userImage = json['userImage'];
  }
//Convert App data to JSON file
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['user_id'] = this.user_id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['userImage'] = this.userImage;

    return data;
  }
}
