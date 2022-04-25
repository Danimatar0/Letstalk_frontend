import 'dart:convert';

class LoggedUser {
  int id;
  String username;
  String firstname;
  String lastname;
  String imgUrl;
  String? token;
  String? phone;
  String? dob;
  String? gender;
  String? FirebaseId;
  LoggedUser({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.imgUrl,
    this.token,
    this.phone,
    this.dob,
    this.gender,
    this.FirebaseId,
  });

  LoggedUser copyWith({
    int? id,
    String? username,
    String? firstname,
    String? lastname,
    String? imgUrl,
    String? token,
    String? phone,
    String? dob,
    String? gender,
    String? FirebaseId,
  }) {
    return LoggedUser(
      id: id ?? this.id,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      imgUrl: imgUrl ?? this.imgUrl,
      token: token ?? this.token,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      FirebaseId: FirebaseId ?? this.FirebaseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'imgUrl': imgUrl,
      'token': token,
      'phone': phone,
      'dob': dob,
      'gender': gender,
      'FirebaseId': FirebaseId,
    };
  }

  factory LoggedUser.fromMap(Map<String, dynamic> map) {
    return LoggedUser(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
      token: map['token'],
      phone: map['phone'],
      dob: map['dob'],
      gender: map['gender'],
      FirebaseId: map['FirebaseId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoggedUser.fromJson(String source) =>
      LoggedUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LoggedUser(id: $id, username: $username, firstname: $firstname, lastname: $lastname, imgUrl: $imgUrl, token: $token, phone: $phone, dob: $dob, gender: $gender, FirebaseId: $FirebaseId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoggedUser &&
        other.id == id &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.imgUrl == imgUrl &&
        other.token == token &&
        other.phone == phone &&
        other.dob == dob &&
        other.gender == gender &&
        other.FirebaseId == FirebaseId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        imgUrl.hashCode ^
        token.hashCode ^
        phone.hashCode ^
        dob.hashCode ^
        gender.hashCode ^
        FirebaseId.hashCode;
  }
}
