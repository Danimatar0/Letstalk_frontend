import 'dart:convert';

class LoggedUser {
  int id;
  String username;
  String firstname;
  String lastname;
  String imgUrl;
  LoggedUser({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.imgUrl,
  });

  LoggedUser copyWith({
    int? id,
    String? username,
    String? firstname,
    String? lastname,
    String? imgUrl,
  }) {
    return LoggedUser(
      id: id ?? this.id,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'imgUrl': imgUrl,
    };
  }

  factory LoggedUser.fromMap(Map<String, dynamic> map) {
    return LoggedUser(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoggedUser.fromJson(String source) =>
      LoggedUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LoggedUser(id: $id, username: $username, firstname: $firstname, lastname: $lastname, imgUrl: $imgUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoggedUser &&
        other.id == id &&
        other.username == username &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.imgUrl == imgUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        imgUrl.hashCode;
  }
}
