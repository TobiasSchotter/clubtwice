import 'package:clubtwice/core/model/Search.dart';

class SearchService {
  static List<SearchHistory> listSearchHistory = listSearchHistoryRawData
      .map((data) => SearchHistory.fromJson(data))
      .toList();
}

var listSearchHistoryRawData = [
  {'title': 'Nike Air Jordan'},
  {'title': 'Adidas Alphabounce'},
  {'title': 'Curry 5'},
  {'title': 'Jordan BRED'},
  {'title': 'Heiden Heritage Xylo'},
  {'title': 'Ventela Public'},
];
