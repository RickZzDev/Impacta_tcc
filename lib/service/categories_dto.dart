class CategoryDto {
  late List<Data> data;

  CategoryDto({required this.data});

  CategoryDto.fromJson(Map<String, dynamic> json) {
    data = <Data>[];
    json['data'].forEach((v) {
      data.add(Data.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }
}

class Data {
  late int id;
  late String title;
  late String maxValue;
  late String createdAt;
  late List<Debits> debits;
  late String debitsSum;

  Data(
      {required this.id,
      required this.title,
      required this.maxValue,
      required this.createdAt,
      required this.debits,
      required this.debitsSum});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    maxValue = json['maxValue'];
    createdAt = json['created_at'];
    if (json['debits'] != null) {
      debits = <Debits>[];
      json['debits'].forEach((v) {
        debits.add(Debits.fromJson(v));
      });
    }
    debitsSum = json['debitsSum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['maxValue'] = maxValue;
    data['created_at'] = createdAt;
    data['debits'] = debits.map((v) => v.toJson()).toList();

    data['debitsSum'] = debitsSum;
    return data;
  }
}

class Debits {
  late int id;
  late int categoryId;
  late String title;
  late String value;
  late String createdAt;
  late String updatedAt;

  Debits(
      {required this.id,
      required this.categoryId,
      required this.title,
      required this.value,
      required this.createdAt,
      required this.updatedAt});

  Debits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['title'] = title;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
