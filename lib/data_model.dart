import 'dart:convert';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  String phoneNumber;
  List<String> pic;
  String address;
  String fbLink;
  String instaLink;
  String wpSendMsgLink;
  String logo;

  Data({
    required this.phoneNumber,
    required this.pic,
    required this.address,
    required this.fbLink,
    required this.instaLink,
    required this.wpSendMsgLink,
    required this.logo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        phoneNumber: json["phoneNumber"],
        pic: List<String>.from(json["pic"].map((x) => x)),
        address: json["address"],
        fbLink: json["fbLink"],
        instaLink: json["instaLink"],
        wpSendMsgLink: json["wpSendMsgLink"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "pic": List<dynamic>.from(pic.map((x) => x)),
        "address": address,
        "fbLink": fbLink,
        "instaLink": instaLink,
        "wpSendMsgLink": wpSendMsgLink,
        "logo": logo,
      };
}
