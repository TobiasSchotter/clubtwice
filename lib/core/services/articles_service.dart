import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/article.dart';

class ArticleService {
  Future<List<Article>> fetchArticles(String searchTerm, String verein) async {
    if (verein != '' && verein.isNotEmpty) {
      Query articlesQuery = FirebaseFirestore.instance
          .collection('articles')
          .where('club', isEqualTo: verein)
          .where('isSold', isEqualTo: false)
          .where('isReserved', isEqualTo: false)
          .where('isDeleted', isEqualTo: false);

      QuerySnapshot articleSnapshot = await articlesQuery.get();

      List<Article> articles = [];

      for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
        Article article = Article.fromFirestore(doc);
        if (article.title.toLowerCase().contains(searchTerm.toLowerCase())) {
          articles.add(article);
        }
      }

      articles.sort((b, a) => a.createdAt.compareTo(b.createdAt));

      return articles;
    } else {
      print("fetchArticles: Verein ist leer");
      // TODO: error handling
      return [];
    }
  }
}
