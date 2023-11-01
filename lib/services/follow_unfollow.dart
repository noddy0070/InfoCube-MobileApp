import 'package:flutter/material.dart';
import 'package:fucare_android_studio/Pages/navbar.dart';
import 'package:fucare_android_studio/Pages/profile_view.dart';
import 'package:fucare_android_studio/services/userdataformat.dart';
import 'package:fucare_android_studio/services/userdata.dart';
import 'package:get/get.dart';

follow(BuildContext context) {
  Userdetail userdetail = Get.find();
  DateTime now = DateTime.now();
  ProfileViewController profileViewController = Get.find();
  String userdocumentid = "";
  String profiledocumentid = "";
  profileViewController.isloading.value = true;
  fetchDocumentid() async {
    userdocumentid = await DatabaseManager()
        .getDocumentId(userdetail.currentuser.value[0]["Email"]);
    profiledocumentid = await DatabaseManager()
        .getDocumentId(profileViewController.currentuser.value[0]["Email"]);
  }

  fetchDocumentid().whenComplete(() {
    FollowUnfollowData followingData = FollowUnfollowData(
        currentdatetime: now,
        senderemail: profileViewController.currentuser.value[0]["Email"]);
    FollowUnfollowData followerData = FollowUnfollowData(
        currentdatetime: now,
        senderemail: userdetail.currentuser.value[0]["Email"]);
    int following = userdetail.currentuser.value[0]["Following"] + 1;
    int followers = profileViewController.currentuser.value[0]["Followers"] + 1;
    FollowUser(context)
        .followUser(followerData, followingData, userdocumentid,
            profiledocumentid, following, followers)
        .whenComplete(() {
      userdetail.fetchCurrentUser();
      profileViewController.isfollowingchecker().whenComplete(() {
        profileViewController
            .fetchProfileUser()
            .whenComplete(() => profileViewController.isloading.value = false);
      });
    });
  });
}

unfollow(BuildContext context) {
  Userdetail userdetail = Get.find();
  ProfileViewController profileViewController = Get.find();
  String userdocumentid = "";
  String profiledocumentid = "";
  String followingdocumentid = "";
  String followerdocumentid = "";
  profileViewController.isloading.value = true;
  fetchDocumentid() async {
    userdocumentid = await DatabaseManager()
        .getDocumentId(userdetail.currentuser.value[0]["Email"]);
    profiledocumentid = await DatabaseManager()
        .getDocumentId(profileViewController.currentuser.value[0]["Email"]);
  }

  fetchDocumentid2() async {
    followingdocumentid = await DatabaseManager().getDocumentIduserdetail(
        profileViewController.currentuser.value[0]["Email"],
        userdocumentid,
        "Following");
    followerdocumentid = await DatabaseManager().getDocumentIduserdetail(
        userdetail.currentuser.value[0]["Email"],
        profiledocumentid,
        "Followers");
  }

  fetchDocumentid().whenComplete(
    () {
      fetchDocumentid2().whenComplete(() {
        int following = userdetail.currentuser.value[0]["Following"] - 1;
        int followers =
            profileViewController.currentuser.value[0]["Followers"] - 1;
        UnfollowUser(context)
            .unfollowUser(userdocumentid, followingdocumentid,
                profiledocumentid, followerdocumentid, following, followers)
            .whenComplete(() {
          userdetail.fetchCurrentUser();
          profileViewController.isfollowingchecker().whenComplete(() {
            profileViewController.fetchProfileUser().whenComplete(
                () => profileViewController.isloading.value = false);
          });
        });
      });
    },
  );
}
