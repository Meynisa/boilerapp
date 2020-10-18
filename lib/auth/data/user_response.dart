class UserResponse {
  UserData userData;
  UserMeta meta;

  UserResponse.fromJson(Map<String, dynamic> map)
      : userData = UserData.fromJson(map["data"]),
        meta = UserMeta.fromJson(map["meta"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = data == null ? null : userData.toJson();
    data['meta'] = meta == null ? null : meta.toJson();
    return data;
  }
}

class UserMeta {
  List<String> include;

  UserMeta.fromJson(Map<String, dynamic> map)
      : include = List<String>.from(map["include"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['include'] = include;
    return data;
  }
}

class UserData {
  String type;
  String id;
  UserAttributes attributes;

  UserData.fromJson(Map<String, dynamic> map)
      : type = map["type"],
        id = map["id"],
        attributes = UserAttributes.fromJson(map["attributes"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['id'] = id;
    data['attributes'] = attributes == null ? null : attributes.toJson();
    return data;
  }
}

class UserAttributes {
  String fullName;
  String handphone;
  String email;
  String profilePicture;
  bool isVerified;
  int status;
  String roles;
  Object code;
  AttributesBank bank;
  String saldo;
  String createdBy;
  Info info;
  List<QuizMandatoryDetail> quizMandatoryDetail;
  bool quizMandatoryStatus;
  String createdAt;
  String updateAt;

  UserAttributes.fromJson(Map<String, dynamic> map) {
    try {
      fullName = map["full_name"] == null ? '' : map["full_name"];
      handphone = map["handphone"] == null ? '' : map["handphone"];
      email = map["email"] == null ? '' : map["email"];
      profilePicture =
          map["profile_picture"] == null ? '' : map["profile_picture"];
      isVerified = map["is_verified"] == null ? false : map["is_verified"];
      status = map["status"] == null ? 0 : map["status"];
      roles = map["roles"] == null ? '' : map["roles"];
      code = map["code"] == null ? null : map["code"];
      saldo = map["saldo"] == null ? '0' : map["saldo"];
      createdBy = map["created_by"] == null ? '' : map["created_by"];
      bank = map["bank"] == null ? null : AttributesBank.fromJson(map["bank"]);
      info = map["info"] == null ? null : Info.fromJson(map["info"]);
      quizMandatoryDetail = List<QuizMandatoryDetail>.from(
          map["quiz_mandatory_detail"]
              .map((it) => QuizMandatoryDetail.fromJson(it)));
      quizMandatoryStatus = map["quiz_mandatory_status"] == null ? false : map["quiz_mandatory_status"];
      createdAt = map["created_at"] == null ? '' : map["created_at"];
      updateAt = map["updated_at"] == null ? '' : map["updated_at"];
    } catch (e) {
      print('e: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = fullName;
    data['handphone'] = handphone;
    data['email'] = email;
    data['profile_picture'] = profilePicture;
    data['is_verified'] = isVerified;
    data['status'] = status;
    data['roles'] = roles;
    data['code'] = code;
    data['saldo'] = saldo;
    data['created_by'] = createdBy;
    data['bank'] = bank == null ? null : info.toJson();
    data['info'] = info == null ? null : info.toJson();
    data['quiz_mandatory_detail'] = quizMandatoryDetail != null
        ? quizMandatoryDetail.map((v) => v.toJson()).toList()
        : null;
    data['quiz_mandatory_status'] = quizMandatoryStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updateAt;
    return data;
  }
}

class AttributesBank {
  String code;
  String name;
  String accountName;
  String accountNumber;

  AttributesBank({
    this.code,
    this.name,
    this.accountName,
    this.accountNumber,
  });

  factory AttributesBank.fromJson(Map<String, dynamic> json) => AttributesBank(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        accountName: json["account_name"] == null ? null : json["account_name"],
        accountNumber:
            json["account_number"] == null ? null : json["account_number"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "account_name": accountName == null ? null : accountName,
        "account_number": accountNumber == null ? null : accountNumber,
      };
}

class Info {
  String type;
  InfoData infoData;

  Info.fromJson(Map<String, dynamic> map) {
    try {
      type = map["type"];
      infoData = InfoData.fromJson(map["data"]);
    } catch (e) {
      print('e: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['data'] = infoData == null ? null : infoData.toJson();
    return data;
  }
}

class InfoData {
  String noKtp;
  IdentificationData ktp;
  IdentificationData selfiKtp;
  String noNpwp;
  IdentificationData npwp;
  String campaignActive;
  bool isValid;
  String dateValid;
  bool retryUpload;
  String verifiedBy;
  String offlineSeminarStatus;

  InfoData.fromJson(Map<String, dynamic> map) {
    try{
      noKtp = map["no_ktp"] == null ? "" : map["no_ktp"];
      ktp = map["ktp"] == null ? null : IdentificationData.fromJson(map["ktp"]);
      selfiKtp = map["selfi_ktp"] == null
          ? null
          : IdentificationData.fromJson(map["selfi_ktp"]);
      noNpwp = map["no_npwp"] == null ? "" : map["no_npwp"];
      npwp =
      map["npwp"] == null ? null : IdentificationData.fromJson(map["npwp"]);
      campaignActive =
      map["campaign_active"] == null ? "" : map["campaign_active"];
      isValid = map["is_valid"] == null ? false : map["is_valid"];
      dateValid = map["date_valid"] == null ? "" : map["date_valid"];
      retryUpload = map["retry_upload"] == null ? false : map["retry_upload"];
      verifiedBy = map["verified_by"] == null ? "" : map["verified_by"];
      offlineSeminarStatus = map["offline_seminar_status"] == null
          ? false
          : map["offline_seminar_status"];
    }catch(e){
      print('ERROR INFO_DATA: ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no_ktp'] = noKtp;
    data['ktp'] = ktp == null ? null : ktp.toJson();
    data['selfi_ktp'] = selfiKtp == null ? null : selfiKtp.toJson();
    data['no_npwp'] = noNpwp;
    data['npwp'] = npwp == null ? null : npwp.toJson();
    data['campaign_active'] = campaignActive;
    data['is_valid'] = isValid;
    data['date_valid'] = dateValid;
    data['retry_upload'] = retryUpload;
    data['verified_by'] = verifiedBy;
    data['offline_seminar_status'] = offlineSeminarStatus;
    return data;
  }
}

class IdentificationData {
  String id;
  String extension;
  String mimeType;

  IdentificationData.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        extension = map["extension"],
        mimeType = map["mime_type"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['extension'] = extension;
    data['mime_type'] = mimeType;
    return data;
  }
}

class QuizMandatoryDetail {
  bool isPassed;
  String scoreThreshold;
  String moduleId;
  String moduleTitle;

  QuizMandatoryDetail.fromJson(Map<String, dynamic> map)
      : isPassed = map["is_passed"],
        scoreThreshold = map["score_threshold"],
        moduleId = map["module_id"],
        moduleTitle = map["module_title"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_passed'] = isPassed;
    data['score_threshold'] = scoreThreshold;
    data['module_id'] = moduleId;
    data['module_title'] = moduleTitle;
    return data;
  }
}
