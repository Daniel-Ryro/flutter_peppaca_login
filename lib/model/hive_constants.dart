//import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

const settingBox = "Setting";
const categoryBox = "Category";
const subCategoryBox = "SubCategory";
const subsubCatgoryBox = "SubSubCategory";
const shoppingCartBox = "Cart";
const productBox = "Porduct"; // seller product listings or product caching

// insert/update key-value pair
void boxAddValue(Map<String, dynamic> mapData, Box hiveBox) {
  mapData.forEach((key, value) async {
    await hiveBox.put(key, value);
  });
}

void boxDeleteValue(List<String> listData, Box hiveBox) {
  for (String key in listData) {
    hiveBox.delete(key);
  }
}

void boxPrintContents(Box hiveBox) {
  // if (Constants.kDebugMode) {
  //   String boxName = hiveBox.name;
  //   // ignore: avoid_print
  //   print('Contents of $boxName:');

  //   hiveBox.toMap().forEach((key, value) {
  //     // ignore: avoid_print
  //     print('$key : $value');
  //   });

  //   // ignore: avoid_print
  //   print('\n');
  // }
}
