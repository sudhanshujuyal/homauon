
class AppInfo {
  String? response;
  List<Message>? message;

  AppInfo({this.response, this.message});

  AppInfo.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? appId;
  String? erpName;
  String? appName;
  String? appLink;
  String? appUrl;
  String? appStoreLink;
  String? appVersionCode;
  String? appVersionName;
  String iosAppVersionCode="0";
  String iosAppVersionName="";
  String? updatetime;

  Message(
      {this.appId,
        this.erpName,
        this.appName,
        this.appLink,
        this.appUrl,
        this.appStoreLink,
        this.appVersionCode,
        this.appVersionName,
        required this.iosAppVersionCode,
        required this.iosAppVersionName,
        this.updatetime});

  Message.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    erpName = json['erp_name'];
    appName = json['app_name'];
    appLink = json['app_link'];
    appUrl = json['app_url'];
    appStoreLink = json['app_store_link'];
    appVersionCode = json['app_version_code'];
    appVersionName = json['app_version_name'];
    iosAppVersionCode = json['ios_app_version_code'];
    iosAppVersionName = json['ios_app_version_name'];
    updatetime = json['updatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['erp_name'] = this.erpName;
    data['app_name'] = this.appName;
    data['app_link'] = this.appLink;
    data['app_url'] = this.appUrl;
    data['app_store_link'] = this.appStoreLink;
    data['app_version_code'] = this.appVersionCode;
    data['app_version_name'] = this.appVersionName;
    data['ios_app_version_code'] = this.iosAppVersionCode;
    data['ios_app_version_name'] = this.iosAppVersionName;
    data['updatetime'] = this.updatetime;
    return data;
  }
}