class UserData {
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String email;
  final String password;
  final String education;
  final List interest;
  final String type;
  final String profileimageurl;
  final String bio;
  final List region;
  final String linkedinUrl;
  final String workingAt;
  final String designation;
  final String portfolioUrl;
  final int following;
  final List<String> saved;
  final List<String> liked;
  final int followers;

  const UserData({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.email,
    required this.password,
    required this.education,
    required this.interest,
    required this.region,
    this.type = "User",
    this.profileimageurl = "assets/images/defaultprofile.jpg",
    this.bio = "",
    this.linkedinUrl = '',
    this.designation = '',
    this.portfolioUrl = '',
    this.workingAt = '',
    this.following = 0,
    this.followers = 0,
    this.liked = const [],
    this.saved = const [],
  });

  toJson() {
    return {
      "First Name": firstName,
      "Last Name": lastName,
      "Date of Birth": dob,
      "Education": education,
      "Password": password,
      "Email": email,
      "Gender": gender,
      "Field of Interest": interest,
      "Type": type,
      "ProfileUrl": profileimageurl,
      "Bio": bio,
      "LinkedIn Url ": linkedinUrl,
      "Working At": workingAt,
      "Designation": designation,
      "Portfolio Url": portfolioUrl,
      "Following": following,
      "Followers": followers,
      "Saved": saved,
      "Liked": liked,
      "Region": region
    };
  }
}

class UserDataUpdated {
  final String firstName;
  final String lastName;
  final String dob;
  final String bio;
  final String linkedinUrl;
  final String workingAt;
  final String designation;
  final String portfolioUrl;

  const UserDataUpdated({
    required this.firstName,
    required this.lastName,
    required this.dob,
    this.bio = "",
    this.linkedinUrl = '',
    this.designation = '',
    this.portfolioUrl = '',
    this.workingAt = '',
  });

  toJson() {
    return {
      "First Name": firstName,
      "Last Name": lastName,
      "Date of Birth": dob,
      "Bio": bio,
      "LinkedIn Url ": linkedinUrl,
      "Working At": workingAt,
      "Designation": designation,
      "Portfolio Url": portfolioUrl,
    };
  }
}

class MessageData {
  final String sender;
  final DateTime currentdatetime;
  final String message;
  final String imageurl;
  final String uid;

  const MessageData({
    required this.uid,
    required this.sender,
    required this.currentdatetime,
    this.message = '',
    this.imageurl = '',
  });
  toJson() {
    return {
      "Uid": uid,
      "Email": sender,
      "Date": currentdatetime,
      "Message": message,
      "ImageUrl": imageurl,
    };
  }
}

class PostData {
  final String uid;
  final String senderemail;
  final DateTime currentdatetime;
  final String message;
  final String imagepath;
  final String tag;
  final List<String> likeduser;
  final List<String> saveduser;
  final int height;
  final int width;

  const PostData(
      {required this.uid,
      required this.senderemail,
      required this.currentdatetime,
      required this.tag,
      this.height = 0,
      this.width = 0,
      this.message = '',
      this.imagepath = '',
      this.likeduser = const [],
      this.saveduser = const []});
  toJson() {
    return {
      "Uid": uid,
      "Email": senderemail,
      "Date": currentdatetime,
      "Message": message,
      "Imagepath": imagepath,
      "Tag": tag,
      "Liked": likeduser,
      "Saved": saveduser,
      "Height": height,
      "Width": width
    };
  }
}

class FollowUnfollowData {
  final String senderemail;
  final DateTime currentdatetime;

  const FollowUnfollowData({
    required this.senderemail,
    required this.currentdatetime,
  });
  toJson() {
    return {
      "Email": senderemail,
      "Date": currentdatetime,
    };
  }
}
