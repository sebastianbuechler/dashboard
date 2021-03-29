class User {
  late String iD;
  late Profile profile;

  User({
    required this.iD,
    required this.profile,
  });

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    profile =
        (json['Profile'] != null ? Profile.fromJson(json['Profile']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Profile'] = this.profile.toJson();
    return data;
  }
}

class Profile {
  late String mobile;
  late String firstName;
  late String lastName;
  late String email;
  late String title;
  late String street;
  late String streetNumber;
  late String postCode;
  late String city;
  late String country;
  late String iDDocumentType;
  late String iDDocumentNumber;
  late String civilStatus;
  late String nationality;
  late String placeOfOrigin;
  late String dateOfBirth;
  late String sex;

  Profile(
      {required this.mobile,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.title,
      required this.street,
      required this.streetNumber,
      required this.postCode,
      required this.city,
      required this.country,
      required this.iDDocumentType,
      required this.iDDocumentNumber,
      required this.civilStatus,
      required this.nationality,
      required this.placeOfOrigin,
      required this.dateOfBirth,
      required this.sex});

  Profile.fromJson(Map<String, dynamic> json) {
    mobile = json['Mobile'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    email = json['Email'];
    title = json['Title'];
    street = json['Street'];
    streetNumber = json['StreetNumber'];
    postCode = json['PostCode'];
    city = json['City'];
    country = json['Country'];
    iDDocumentType = json['IDDocumentType'];
    iDDocumentNumber = json['IDDocumentNumber'];
    civilStatus = json['CivilStatus'];
    nationality = json['Nationality'];
    placeOfOrigin = json['PlaceOfOrigin'];
    dateOfBirth = json['DateOfBirth'];
    sex = json['Sex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mobile'] = this.mobile;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Email'] = this.email;
    data['Title'] = this.title;
    data['Street'] = this.street;
    data['StreetNumber'] = this.streetNumber;
    data['PostCode'] = this.postCode;
    data['City'] = this.city;
    data['Country'] = this.country;
    data['IDDocumentType'] = this.iDDocumentType;
    data['IDDocumentNumber'] = this.iDDocumentNumber;
    data['CivilStatus'] = this.civilStatus;
    data['Nationality'] = this.nationality;
    data['PlaceOfOrigin'] = this.placeOfOrigin;
    data['DateOfBirth'] = this.dateOfBirth;
    data['Sex'] = this.sex;
    return data;
  }
}
