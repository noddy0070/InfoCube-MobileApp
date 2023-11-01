import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/chat.dart';
import 'package:fucare_android_studio/Pages/contents.dart';
import 'package:fucare_android_studio/Pages/home.dart';
import 'package:fucare_android_studio/Pages/profile.dart';
import 'package:fucare_android_studio/Pages/profile_view.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:get/get.dart';

class Userdetail extends GetxController {
  final Rx<dynamic> currentuser = Rx<dynamic>(null);
  final length = 0.obs;
  final Rx<dynamic> feed = Rx<dynamic>(null);
  final userdatalist = [].obs;
  final length2 = 0.obs;
  final Rx<List<dynamic>> feedlist = Rx([]);
  final pageselected = "Home".obs;
  final postEmail = "".obs;
  RxBool islaoding = true.obs;

  Future<void> fetchCurrentUser() async {
    final user = await DatabaseManager().getCurrentUser();
    currentuser.value = user;
    length.value = user[0]['Field of Interest'].length;
  }

  Future<void> fetchAllUser() async {
    List<dynamic> userDataList = await DatabaseManager().getUserProfileList();
    userdatalist.value = userDataList;
    
  }

  Future<void> fetchfeed() async {
    Stream<QuerySnapshot> userStream = DatabaseManager().getFeedItem();

    userStream.listen((QuerySnapshot quersnapshot) {
      feedlist.value = [];
      for (QueryDocumentSnapshot doc in quersnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        feed.value = data;
        feedlist.value.add(feed.value);

        length2.value = feedlist.value.length;
      }
      islaoding.value = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
    // Call the asynchronous function when the controller is initialized
    fetchCurrentUser();
    fetchAllUser();
    fetchfeed();
  }
}

// Define your four page

class MenuItem {
  const MenuItem(this.iconData, this.text);
  final IconData iconData;
  final String text;
}

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  Userdetail userdetail = Get.put(Userdetail());
  late ProfileViewController profileViewController;

  final List<Widget> pages = [
    const HomeFeeds(),
    const Community(),
    Content(),
    const ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    bool cond = userdetail.pageselected.value != "Home";
    return cond
        ?  (
           
            userdetail.pageselected.value = "Home",
            selectedIndex.value = 0
          )
        : (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to exit an App'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), //<-- SEE HERE
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // <-- SEE HERE
                    child: const Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
  }

  // Menu item list with icons and text
  final menuItemlist = const <MenuItem>[
    MenuItem(Icons.home, 'Home'),
    MenuItem(Icons.chat, 'Chat'),
    MenuItem(Icons.file_copy_sharp, 'Content'),
    MenuItem(Icons.person, 'Profile'),
  ];
  final pageselected = const <String>[
    "Home",
    "Community",
    "Content",
    "Profile"
  ];
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Obx(() => pages[selectedIndex.value]),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 229, 229, 229),
              elevation: 16.0,
              showUnselectedLabels: false,
              unselectedItemColor: const Color.fromARGB(137, 99, 99, 99),
              selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              items: menuItemlist
                  .map((MenuItem menuItem) => BottomNavigationBarItem(
                        backgroundColor:
                            const Color.fromARGB(255, 229, 229, 229),
                        icon: Icon(menuItem.iconData),
                        label: menuItem.text,
                      ))
                  .toList(),
              currentIndex: selectedIndex.value,
              onTap: (index) {
                selectedIndex.value = index;
                userdetail.pageselected.value = pageselected[index];
              },
            )),
      ),
    );
  }
}
