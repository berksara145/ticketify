class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  int? money;
  String? password;
  int? userId;
  String? userType;

  UserModel(
      {this.email,
      this.firstName,
      this.lastName,
      this.money,
      this.password,
      this.userId,
      this.userType});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    money = json['money'];
    password = json['password'];
    userId = json['user_id'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['money'] = this.money;
    data['password'] = this.password;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    return data;
  }
}
