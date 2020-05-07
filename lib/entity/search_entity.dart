class SearchEntity {
  Head head;
  List<Data> data;

  SearchEntity({this.head, this.data});

  SearchEntity.fromJson(Map<String, dynamic> json) {
    head = json['head'] != null ? new Head.fromJson(json['head']) : null;
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.head != null) {
      data['head'] = this.head.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Head {
  Null auth;
  String errcode;

  Head({this.auth, this.errcode});

  Head.fromJson(Map<String, dynamic> json) {
    auth = json['auth'];
    errcode = json['errcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['auth'] = this.auth;
    data['errcode'] = this.errcode;
    return data;
  }
}

class Data {
  String code;
  String word;
  String type;
  String url;
  String districtname;
  String price;

  Data(
      {this.code,
        this.word,
        this.type,
        this.url,
        this.districtname,
        this.price});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    word = json['word'];
    type = json['type'];
    url = json['url'];
    districtname = json['districtname'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['word'] = this.word;
    data['type'] = this.type;
    data['url'] = this.url;
    data['districtname'] = this.districtname;
    data['price'] = this.price;
    return data;
  }
}