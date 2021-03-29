class OnboardingRegister {
  late String firstName;
  late String lastName;
  late String email;
  late String phone;
  late String password;

  OnboardingRegister({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  OnboardingRegister.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    lastName = json['LastName'];
    email = json['Email'];
    phone = json['Phone'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Password'] = this.password;
    return data;
  }
}
