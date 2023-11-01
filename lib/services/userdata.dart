// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fucare_android_studio/services/userdataformat.dart';

import 'package:get/get.dart';

///Function to Retrive data//--------------------------------------------------------------------
class DatabaseManager {
  final CollectionReference userdatalist =
      FirebaseFirestore.instance.collection('UserDetails');
  final CollectionReference contentdatalist =
      FirebaseFirestore.instance.collection("Content");
  final CollectionReference feedlist =
      FirebaseFirestore.instance.collection("Feed");
  final CollectionReference messagedatalist =
      FirebaseFirestore.instance.collection("Messages");
  CollectionReference<Map<String, dynamic>> userdatalist2 =
      FirebaseFirestore.instance.collection('UserDetails');

  FirebaseStorage storage = FirebaseStorage.instance;
  List contentdata = [];
  List userdata = [];
  List messagedata = [];
  String imageUrl = '';

  /// GET the list of all the users avalable in userdetails collection
  Future getUserProfileList() async {
    try {
      QuerySnapshot querySnapshot = await userdatalist.get();
      // Process the data from the querySnapshot
      for (var element in querySnapshot.docs) {
        userdata.add(element.data());
      }
      // Now you can work with 'data' as needed
      return userdata;
    } catch (e) {
      return null;
    }
  }

  Future getDocumentId(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await userdatalist2.get();

      // Iterate through the documents and get the document IDs
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        String documentID = documentSnapshot.id;
        final doc = documentSnapshot.data();
        if (doc["Email"] == email) {
          return documentID;
        }
      }
    } catch (e) {
      return null;
    }
  }

  Future getDocumentIduserdetail(
      String email, String documentId, String collection) async {
    CollectionReference<Map<String, dynamic>> userdatalist3 = FirebaseFirestore
        .instance
        .collection('UserDetails')
        .doc(documentId)
        .collection(collection);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await userdatalist3.get();

      // Iterate through the documents and get the document IDs
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        String documentID = documentSnapshot.id;
        final doc = documentSnapshot.data();
        if (doc["Email"] == email) {
          return documentID;
        }
      }
    } catch (e) {
      return null;
    }
  }

  Future isfollowingchecker(String email, String documentId) async {
    CollectionReference<Map<String, dynamic>> userdatalist3 = FirebaseFirestore
        .instance
        .collection('UserDetails')
        .doc(documentId)
        .collection("Following");
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await userdatalist3.get();

      // Iterate through the documents and get the document IDs
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        // ignore: unused_local_variable
        String documentID = documentSnapshot.id;
        final doc = documentSnapshot.data();
        if (doc["Email"] == email) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  /// GET the current user data
  Future getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String userEmail = '';
    User? user = auth.currentUser;
    if (user != null) {
      userEmail = user.email!; // Get the user's email
    }

    Future<List<dynamic>> fetchUserDatabase(String email) async {
      List<dynamic> userDataList = await DatabaseManager().getUserProfileList();
      List<dynamic> matchingUsers = [];
      for (int i = 0; i < userDataList.length; i++) {
        if (userDataList[i]['Email'] == email) {
          matchingUsers.add(userDataList[i]);
        }
      }

      return matchingUsers;
    }

    return await fetchUserDatabase(userEmail);
  }

  //Get detail of user whose profile is been viewed
  /// GET the current user data
  Future getProfileUser(String email) async {
    Future<List<dynamic>> fetchUserDatabase(String email) async {
      List<dynamic> userDataList = await DatabaseManager().getUserProfileList();
      List<dynamic> matchingUsers = [];
      for (int i = 0; i < userDataList.length; i++) {
        if (userDataList[i]['Email'] == email) {
          matchingUsers.add(userDataList[i]);
        }
      }

      return matchingUsers;
    }

    return await fetchUserDatabase(email);
  }

  //Getting feed item
  Stream<QuerySnapshot> getFeedItem() {
    try {
      return feedlist
          .where('Date', isNull: false)
          .orderBy("Date", descending: true)
          .snapshots();
    } catch (e) {
      return const Stream.empty();
    }
  }

  /// Get the list of all the types of messages field available in message collection
  Stream<QuerySnapshot> getMessagelist(String field) {
    try {
      return messagedatalist
          .doc(field)
          .collection("GlobalChat")
          .where('Date', isNull: false)
          .orderBy('Date', descending: true)
          .snapshots();
    } catch (e) {
      // Handle any exceptions here
      return const Stream.empty(); // Return an empty stream in case of errors
    }
  }

  ///Checks if creator is logging in or user
  Future<bool> isCreator() async {
    dynamic currentuser = await getCurrentUser();
    if (currentuser[0]["Type"] == "Creator") {
      return true;
    }

    return false;
  }

  /// GET the list of all the contents avalable in content collection
  Future getContentData() async {
    try {
      QuerySnapshot querySnapshot = await contentdatalist.get();
      // Process the data from the querySnapshot
      for (var element in querySnapshot.docs) {
        contentdata.add(element.data());
      }
      // Now you can work with 'data' as needed
      return contentdata;
    } catch (e) {
      return null;
    }
  }
}

///Function to manipulate data//--------------------------------------------------------------------
class CreateUserdata extends GetxController {
  final BuildContext context;
  CreateUserdata(this.context);
  static CreateUserdata get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(
    UserData user,
  ) async {
    try {
      // Add the user data to Firestore
      await _db.collection("UserDetails").add(user.toJson(),);
      Get.snackbar("Account Successfully Created.", "");
      // Show a success Snackbar
    } catch (error) {
      // Show an error Snackbar
    }
  }
}

class UpdateUserdata extends GetxController {
  final BuildContext context;
  UpdateUserdata(this.context);
  static UpdateUserdata get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUser(
    String documentId,
    UserDataUpdated user,
  ) async {
    try {
      // Add the user data to Firestore
      await _db.collection("UserDetails").doc(documentId).update(user.toJson());
      Get.snackbar("Profile Updated.", "");
      // Show a success Snackbar
    } catch (error) {
      // Show an error Snackbar
    }
  }
}

class UpdateUserProfilePicdata extends GetxController {
  final BuildContext context;
  UpdateUserProfilePicdata(this.context);
  static UpdateUserProfilePicdata get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUser(
    String documentId,
    Map<String, String> img,
  ) async {
    try {
      // Add the user data to Firestore
      await _db.collection("UserDetails").doc(documentId).update(img);
      Get.snackbar("Profile Picture Updated.", "");
      // Show a success Snackbar
    } catch (error) {
      // Show an error Snackbar
    }
  }
}

// Send Message related data to firebase
class SendMessageData extends GetxController {
  final BuildContext context;
  SendMessageData(this.context);
  static SendMessageData get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageData msgdata, String field) async {
    try {
      // Add the user data to Firestore
      await _db
          .collection("Messages")
          .doc(field)
          .collection("GlobalChat")
          .add(msgdata.toJson());
    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

// Send Post related data to firebase
class SendPostData extends GetxController {
  final BuildContext context;
  SendPostData(this.context);
  static SendPostData get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendPost(PostData postData) async {
    try {
      // Add the user data to Firestore
      await _db.collection("Feed").add(postData.toJson());
    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

// Send Post related data to firebase
class FollowUser extends GetxController {
  final BuildContext context;
  FollowUser(this.context);
  static FollowUser get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> followUser(
      FollowUnfollowData followingData,
      FollowUnfollowData followerData,
      String userdocumentid,
      String profiledocumentid,
      int following,
      int followers) async {
    try {
      // Add the user data to Firestore
      await _db
          .collection("UserDetails")
          .doc(userdocumentid)
          .collection("Following")
          .add(followerData.toJson());
      await _db
          .collection("UserDetails")
          .doc(userdocumentid)
          .update({"Following": following});

      await _db
          .collection("UserDetails")
          .doc(profiledocumentid)
          .collection("Followers")
          .add(followingData.toJson());
      await _db
          .collection("UserDetails")
          .doc(profiledocumentid)
          .update({"Followers": followers});
    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

class UnfollowUser extends GetxController {
  final BuildContext context;
  UnfollowUser(this.context);
  static UnfollowUser get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> unfollowUser(
      String userdocumentid,
      String followdocumentid,
      String profiledocumentid,
      String followingdocumentid,
      int following,
      int followers) async {
    try {
      // Add the user data to Firestore
      await _db
          .collection("UserDetails")
          .doc(userdocumentid)
          .collection("Following")
          .doc(followdocumentid)
          .delete();
      await _db
          .collection("UserDetails")
          .doc(userdocumentid)
          .update({"Following": following});

      await _db
          .collection("UserDetails")
          .doc(profiledocumentid)
          .collection("Followers")
          .doc(followingdocumentid)
          .delete();
      await _db
          .collection("UserDetails")
          .doc(profiledocumentid)
          .update({"Followers": followers});
    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

class DeleteMessage extends GetxController {
  final BuildContext context;
  DeleteMessage(this.context);
  static DeleteMessage get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> deleteMessage(
    String messagedocumentid,
    String field,
  ) async {
    try {
      // Add the user data to Firestore
      await _db
          .collection("Messages")
          .doc(field)
          .collection("GlobalChat")
          .doc(messagedocumentid)
          .delete();

    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

class DeletePost extends GetxController {
  final BuildContext context;
  DeletePost(this.context);
  static DeletePost get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> deleteMessage(
    String postdocumentid,
  ) async {
    try {
      // Add the user data to Firestore
      await _db.collection("Feed").doc(postdocumentid).delete();

    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

class LikeUnlikePost extends GetxController {
  final BuildContext context;
  LikeUnlikePost(this.context);
  static LikeUnlikePost get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> likeUnlikePost(String userdocumentid, String postdocumentid,
      List likedlistuser, List likedlistpost) async {
    try {
      // Add the user data to Firestore
      await _db
          .collection("UserDetails")
          .doc(userdocumentid)
          .update({"Liked": likedlistuser});

      await _db
          .collection("Feed")
          .doc(postdocumentid)
          .update({"Liked": likedlistpost});
    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}

class SaveUnsavePost extends GetxController {
  final BuildContext context;
  SaveUnsavePost(this.context);
  static SaveUnsavePost get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUnsavePost(String userdocumentid, String postdocumentid,
      List savedlistuser, List savedlistpost) async {
    try {
      // Add the user data to Firestore
      await _db
          .collection("UserDetails")
          .doc(userdocumentid)
          .update({"Saved": savedlistuser});

      await _db
          .collection("Feed")
          .doc(postdocumentid)
          .update({"Saved": savedlistpost});
    } catch (error) {
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid details"),
      ));
    }
  }
}
