class SearchHistory {
  String title;

  SearchHistory({this.title = ""});

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(title: json['title']);
  }
}
