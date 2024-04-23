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
  String about;
  String contact;

  Data(
      {required this.phoneNumber,
      required this.pic,
      required this.address,
      required this.fbLink,
      required this.instaLink,
      required this.wpSendMsgLink,
      required this.logo,
      required this.about,
      required this.contact});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      phoneNumber: json["phoneNumber"],
      pic: List<String>.from(json["pic"].map((x) => x)),
      address: json["address"],
      fbLink: json["fbLink"],
      instaLink: json["instaLink"],
      wpSendMsgLink: json["wpSendMsgLink"],
      logo: json["logo"],
      contact: json["contact"],
      about: json["about"]);

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "pic": List<dynamic>.from(pic.map((x) => x)),
        "address": address,
        "fbLink": fbLink,
        "instaLink": instaLink,
        "wpSendMsgLink": wpSendMsgLink,
        "logo": logo,
        "contact": contact,
        "about": about
      };
}
