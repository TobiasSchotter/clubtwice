import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Search.dart';
import 'package:clubtwice/core/services/SearchService.dart';
import 'package:clubtwice/views/screens/search_result_page.dart';
import 'package:clubtwice/views/widgets/search_history_tile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            autofocus: false,
            style:
                TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
            decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Suche nach Vereinskleidung aller Vereine',
              prefixIcon: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_outlined,
                    color: Colors.white.withOpacity(0.5)),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Search History
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Dein Suchverlauf...',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listSearchHistory.length,
                itemBuilder: (context, index) {
                  return SearchHistoryTile(
                    data: listSearchHistory[index],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchResultPage(
                            searchKeyword: listSearchHistory[index].title,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Suchverlauf löschen',
                    style:
                        TextStyle(color: AppColor.secondary.withOpacity(0.5)),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.primary.withOpacity(0.3),
                    backgroundColor: AppColor.primarySoft,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
