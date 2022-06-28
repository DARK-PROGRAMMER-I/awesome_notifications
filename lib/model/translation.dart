class Translate {
  int? status;
  String? imei;
  List<Word>? word;

  Translate({this.status, this.imei, this.word});

  Translate.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    imei = json['imei'];
    if (json['Word'] != null) {
      word = <Word>[];
      json['Word'].forEach((v) {
        word!.add(new Word.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['imei'] = this.imei;
    if (this.word != null) {
      data['Word'] = this.word!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Word {
  String? eng;
  String? arb;
  String? date;

  Word({this.eng, this.arb, this.date});

  Word.fromJson(Map<String, dynamic> json) {
    eng = json['eng'];
    arb = json['arb'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eng'] = this.eng;
    data['arb'] = this.arb;
    data['date'] = this.date;
    return data;
  }
}
