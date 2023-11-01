import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/Pages/profile_view.dart';
import 'package:fucare_android_studio/services/feed_tile.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:fucare_android_studio/services/create_post.dart';
import 'package:get/get.dart';

class HomeFeeds extends StatefulWidget {
  const HomeFeeds({super.key});

  @override
  State<HomeFeeds> createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds> {
  bool cond = false;
  final _scrollController = ScrollController();
  final Userdetail userdetailcontroller = Get.put(Userdetail());
  TextEditingController searchController = TextEditingController();
  // Function to show the bottom dialog.

  @override
  void initState() {
    super.initState();

    isuser();
  }

  Future<void> isuser() async {
    dynamic result = await DatabaseManager().isCreator();
    setState(() {
      cond = result;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Obx(() {
        String pageselected = userdetailcontroller.pageselected.value;
        return pageselected == "ProfileView"
            ? ProfileView(
                email: userdetailcontroller.postEmail.value,
              )
            : Stack(children: [
                Column(
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 30, 150, 154),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .78,
                              height: 40,
                              decoration: const ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Color.fromARGB(200, 0, 0, 0),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        textAlign: TextAlign.start,
                                        controller: searchController,
                                        style: const TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.black54),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(12.0),
                                          hintText: "Search",
                                          hintStyle: TextStyle(
                                              color:
                                                  Color.fromARGB(191, 0, 0, 0),
                                              fontSize: 20),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications,
                                  size: 40,
                                  color: Color.fromARGB(202, 0, 0, 0),
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .825,
                      child: Obx(() {
                        final len = userdetailcontroller.length2.value;
                        return userdetailcontroller.currentuser.value == null
                            ? const Center(
                                child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator()))
                            : ListView.builder(
                                itemCount: len,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                      onTap: () {},
                                      child: FeedTile(
                                        index: index,
                                      ));
                                });
                      }),
                    ),
                  ],
                ),
                //cond
                if (cond) CreatePost(context: context) else Container(),
              ]);
      }),
    );
  }
}
