import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_app/data_model.dart';
import 'package:share_app/menu.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<String>> pictureListFuture;
  late Data data = Data(
      phoneNumber: '',
      pic: [],
      address: '',
      fbLink: '',
      instaLink: '',
      wpSendMsgLink: '',
      logo: '',
      contact: '',
      about: '');
  @override
  void initState() {
    // TODO: implement initState

    pictureListFuture = fetchPictures();

    fetchData().then((fetchedData) {
      setState(() {
        data = fetchedData;
      });
    }).catchError((error) {
      print('Error fetching data: $error');
    });
    super.initState();
  }

  Future<List<String>> fetchPictures() async {
    final response =
        await http.get(Uri.parse('https://demo6436504.mockable.io/'));

    if (response.statusCode == 200) {
      final data = dataFromJson(response.body);
      return data.pic;
    } else {
      throw Exception('Failed to fetch pictures');
    }
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

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String fbLink = data.fbLink;
    String instaLink = data.instaLink;
    String logo = data.logo;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 240, 240),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70.h),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppBar(
                  elevation: 0,
                  leading: IconButton(
                    icon: Image.asset(
                      "assets/icons/menu_black.png",
                      height: 30.h,
                      width: 30.w,
                    ),
                    onPressed: () {
                      // Scaffold.of(context).openDrawer();
                      Navigator.push(
                        context,
                        LeftSlidePageRoute(
                          page: MenuPage(),
                        ),
                      );
                    },
                  ),
                  actions: [
                    InkWell(
                        onTap: () async {
                          const phoneNumber = 'tel:8240607226';
                          if (await canLaunch(phoneNumber)) {
                            await launch(phoneNumber);
                          } else {
                            throw 'Could not launch $phoneNumber';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/call .png",
                            height: 30.h,
                            width: 30.w,
                          ),
                        ))
                  ],
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: logo == ''
                      ? Container(
                          color: Colors.white,
                        )
                      : Image.network(
                          logo,
                          height: 80.h,
                          // width: 40.w,
                        )),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          children: [
            SizedBox(
              height: 170.h,
              child: FutureBuilder<List<String>>(
                future: pictureListFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final pictureList = snapshot.data!;
                    return CarouselSlider.builder(
                      itemCount: pictureList.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Container(
                            height: 170.h,
                            width: 300.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(pictureList[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 170.h,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.w,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _launchURL(Uri.parse(whatsAppLink));
                        launch('https://wa.me/9433990099');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.amber,
                                foregroundImage:
                                    AssetImage("assets/icons/health 1.png"),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Text(
                                "স্বাস্থ্য  পরিষেবা",
                                style: GoogleFonts.notoSerifBengali(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 191, 45, 35),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // _launchURL(Uri.parse(fbLink));
                        // launchUrl(Uri.parse(whatsAppLink));
                        launch('https://wa.me/8240607226');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.purple,
                                foregroundImage:
                                    AssetImage("assets/icons/grocery.png"),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Text(
                                "বাজার  সামগ্রী",
                                style: GoogleFonts.notoSerifBengali(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.purple),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launch('https://wa.me/8240607226');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 7, 67, 116),
                                foregroundImage:
                                    AssetImage("assets/icons/sound.png"),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Text(
                                "মনের  কথা",
                                style: GoogleFonts.notoSerifBengali(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 60.h,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Link(
              uri: Uri.parse(instaLink),
              target: LinkTarget.defaultTarget,
              builder: (context, followLink) => GestureDetector(
                onTap: followLink,
                child: Image.asset(
                  "assets/icons/Instagram.png",
                  height: 35.h,
                  width: 35.w,
                ),
              ),
            ),
            Link(
              uri: Uri.parse(fbLink),
              target: LinkTarget.defaultTarget,
              builder: (context, followLink) => GestureDetector(
                onTap: followLink,
                child: Image.asset(
                  "assets/icons/Facebook.png",
                  height: 35.h,
                  width: 35.w,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // launchUrl(Uri.parse(whatsAppLink),
                //     mode: LaunchMode.inAppWebView);
                launch('https://wa.me/8240607226');
              },
              child: Text(
                "+91 8240507226",
                style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
