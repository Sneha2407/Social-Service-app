import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_app/data_model.dart';
import 'package:http/http.dart' as http;

class LeftSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  LeftSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(-1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Data data = Data(
      phoneNumber: '',
      pic: [],
      address: '',
      fbLink: '',
      instaLink: '',
      wpSendMsgLink: '',
      logo: '');
  @override
  void initState() {
    // TODO: implement initState

    fetchData().then((fetchedData) {
      setState(() {
        data = fetchedData;
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
    super.initState();
  }

  Future<Data> fetchData() async {
    final response =
        await http.get(Uri.parse('https://demo6436504.mockable.io/'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Data.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String phNo = data.phoneNumber;
    String address = data.address;
    String logo = data.logo;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/icons/close_circle.png",
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          logo == ''
              ? Container(
                  color: Colors.white,
                )
              : CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(logo),
                  radius: 70.r,
                ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            "যোগাযোগ",
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            phNo,
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          Text(
            "support@sathi.app",
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            "ঠিকানা",
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Text(
              address,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          Spacer(),
          Text(
            "© সাথী 2023, all rights reserved",
            style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
