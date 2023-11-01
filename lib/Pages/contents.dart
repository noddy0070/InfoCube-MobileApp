import 'package:flutter/material.dart';
import 'package:fucare_android_studio/widget/buttons.dart';
import 'package:get/get.dart';

class ContentController extends GetxController {
  RxString selectedContent = ''.obs;
  RxList<String> filteredItems = <String>[].obs;
  final List<String> fields = [
    "Astronomy",
    "Aviation",
    "Commerce",
    "Civil Services",
    "Defence",
    "Designing",
    "Engineering",
    "JEE",
    "Lawyer",
    "NEET",
    "Software Development",
    "Startup",
    "Teaching",
    "10th,11th & 12th",
  ];

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    filteredItems.assignAll(fields);
  }

  void filterItems(String query) {
    filteredItems.assignAll(fields
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }
}

class Content extends StatelessWidget {
  Content({super.key});
  final ContentController controller = Get.put(ContentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: Container(
                height: 40,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color.fromARGB(200, 0, 0, 0),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: controller.filterItems,
                          controller: controller.searchController,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black54),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(12.0),
                            hintText: "Search",
                            hintStyle:
                                TextStyle(color: Colors.black54, fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Button Main
            SizedBox(
              height: MediaQuery.of(context).size.height * .79,
              child: Obx(() {
                return ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 60),
                  children: controller.filteredItems.map((field) {
                    return Column(
                      children: [
                        MainBtn(
                          width: double.infinity,
                          fnc: () {
                            controller.selectedContent.value = field;
                            Get.toNamed('/main/content/field');
                          },
                          title: field,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
