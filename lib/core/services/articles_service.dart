import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/Article.dart';

class ArticleWithId {
  final String id;
  final Article article;

  ArticleWithId({required this.id, required this.article});
}

class ArticleService {
  Future<List<ArticleWithId>> _fetchArticles(
      Query articlesQuery, String searchTerm) async {
    QuerySnapshot articleSnapshot = await articlesQuery.get();

    List<ArticleWithId> articles = [];

    for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
      Article article = Article.fromFirestore(doc);
      if (article.title.toLowerCase().contains(searchTerm.toLowerCase())) {
        articles.add(ArticleWithId(id: doc.id, article: article));
      }
    }

    articles.sort((b, a) => a.article.createdAt.compareTo(b.article.createdAt));

    return articles;
  }

  Future<List<ArticleWithId>> fetchArticles(
      String searchTerm, String club) async {
    if (club != '' && club.isNotEmpty) {
      Query articlesQuery = FirebaseFirestore.instance
          .collection('articles')
          .where('club', isEqualTo: club)
          .where('isSold', isEqualTo: false)
          .where('isReserved', isEqualTo: false)
          .where('isDeleted', isEqualTo: false);

      return _fetchArticles(articlesQuery, searchTerm);
    } else {
      print("fetchArticles: Verein ist leer");
      // TODO: error handling
      return [];
    }
  }

  Future<List<ArticleWithId>> fetchUserArticles(
      String searchTerm, String club, String userId) async {
    if (club != '' && club.isNotEmpty) {
      Query articlesQuery = FirebaseFirestore.instance
          .collection('articles')
          .where('userId', isEqualTo: userId);

      return _fetchArticles(articlesQuery, searchTerm);
    } else {
      print("fetchArticles: Verein ist leer");
      // TODO: error handling
      return [];
    }
  }

  Future<List<ArticleWithId>> fetchArticlesClubWide(String searchTerm) async {
    Query articlesQuery = FirebaseFirestore.instance
        .collection('articles')
        .where('isSold', isEqualTo: false)
        .where('isReserved', isEqualTo: false)
        .where('isDeleted', isEqualTo: false);

    return _fetchArticles(articlesQuery, searchTerm);
  }
}
