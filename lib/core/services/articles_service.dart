import 'package:cloud_firestore/cloud_firestore.dart';
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
    List<ArticleWithId> soldArticles = [];
    List<ArticleWithId> deletedArticles = [];

    for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
      Article article = Article.fromFirestore(doc);
      if (article.title.toLowerCase().contains(searchTerm.toLowerCase())) {
        ArticleWithId articleWithId =
            ArticleWithId(id: doc.id, article: article);
        if (article.isSold) {
          soldArticles.add(articleWithId);
        } else if (article.isDeleted) {
          deletedArticles.add(articleWithId);
        } else {
          articles.add(articleWithId);
        }
      }
    }

    // Sort the non-sold and non-deleted articles based on createdAt in descending order
    articles.sort((b, a) => a.article.createdAt.compareTo(b.article.createdAt));
    // Sort the sold articles based on createdAt in descending order
    soldArticles
        .sort((b, a) => a.article.createdAt.compareTo(b.article.createdAt));
    // Sort the deleted articles based on createdAt in descending order
    deletedArticles
        .sort((b, a) => a.article.createdAt.compareTo(b.article.createdAt));

    // Concatenate the lists with non-sold and non-deleted articles first,
    // followed by sold articles, and then deleted articles
    articles.addAll(soldArticles);
    articles.addAll(deletedArticles);

    return articles;
  }

  Future<List<ArticleWithId>> fetchArticles(
    String searchTerm,
    String club,
    String sportart,
    String typ,
    String groesse,
    String marke, {
    int? limit, // optional parameter for limiting the number of documents
    ArticleWithId? startArticle, // optional parameter for startAfter
  }) async {
    if (club.isNotEmpty && club != "Keine Auswahl") {
      Query articlesQuery = FirebaseFirestore.instance
          .collection('articles')
          .where('club', isEqualTo: club)
          .where('isSold', isEqualTo: false)
          .where('isReserved', isEqualTo: false)
          .where('isDeleted', isEqualTo: false);

      // Add additional filters if provided
      if (sportart.isNotEmpty) {
        articlesQuery = articlesQuery.where('sport', isEqualTo: sportart);
      }

      if (typ.isNotEmpty) {
        articlesQuery = articlesQuery.where('type', isEqualTo: typ);
      }

      if (groesse.isNotEmpty) {
        articlesQuery = articlesQuery.where('size', isEqualTo: groesse);
      }

      if (marke.isNotEmpty) {
        articlesQuery = articlesQuery.where('brand', isEqualTo: marke);
      }

      // Apply ordering
      articlesQuery = articlesQuery.orderBy('createdAt', descending: true);

      // If start parameter is provided, use startAfter
      if (startArticle != null) {
        articlesQuery =
            articlesQuery.startAfter([startArticle.article.createdAt]);
      }

      if (limit != null) {
        articlesQuery = articlesQuery.limit(limit);
      }

      // Continue with the searchTerm filtering
      return _fetchArticles(articlesQuery, searchTerm);
    } else {
      return [];
    }
  }

  Future<List<ArticleWithId>> fetchArticlesClubWide(
    String searchTerm,
    String club,
    String sportart,
    String typ,
    String groesse,
    String marke,
  ) async {
    Query articlesQuery = FirebaseFirestore.instance
        .collection('articles')
        .where('isSold', isEqualTo: false)
        .where('isReserved', isEqualTo: false)
        .where('isDeleted', isEqualTo: false);

    // Remove the condition 'isIndividualeWearable' if club is selected
   // if (club.isEmpty) {
    //  articlesQuery =
      //    articlesQuery.where('isIndividuallyWearable', isEqualTo: true);
   // }

    // Add additional filters if provided
    if (club.isNotEmpty) {
      articlesQuery = articlesQuery.where('club', isEqualTo: club);
    }

    if (sportart.isNotEmpty) {
      articlesQuery = articlesQuery.where('sport', isEqualTo: sportart);
    }

    if (typ.isNotEmpty) {
      articlesQuery = articlesQuery.where('type', isEqualTo: typ);
    }

    if (groesse.isNotEmpty) {
      articlesQuery = articlesQuery.where('size', isEqualTo: groesse);
    }

    if (marke.isNotEmpty) {
      articlesQuery = articlesQuery.where('brand', isEqualTo: marke);
    }

    return _fetchArticles(articlesQuery, searchTerm);
  }

  Future<List<ArticleWithId>> fetchUserArticles(
      String searchTerm, String userId) async {
    Query articlesQuery = FirebaseFirestore.instance
        .collection('articles')
        .where('userId', isEqualTo: userId);

    return _fetchArticles(articlesQuery, searchTerm);
  }

  Future<List<ArticleWithId>> fetchUserArticlesExtern(
      String searchTerm, String userId) async {
    Query articlesQuery = FirebaseFirestore.instance
        .collection('articles')
        .where('userId', isEqualTo: userId)
        .where('isSold', isEqualTo: false)
        .where('isReserved', isEqualTo: false)
        .where('isDeleted', isEqualTo: false);

    return _fetchArticles(articlesQuery, searchTerm);
  }

  Future<List<ArticleWithId>> fetchArticlesByIds(
      List<String> articleIds) async {
    List<ArticleWithId> articles = [];

    for (String articleId in articleIds) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('articles')
          .doc(articleId)
          .get();

      if (snapshot.exists) {
        Article article = Article.fromFirestore(snapshot);
        if (!article.isSold && !article.isReserved && !article.isDeleted) {
          articles.add(ArticleWithId(id: snapshot.id, article: article));
        }
      }
    }

    return articles;
  }

  Future<Article> fetchArticleById(String articleId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('articles')
        .doc(articleId)
        .get();

    if (snapshot.exists) {
      Article article = Article.fromFirestore(snapshot);
      return article;
    } else {
      throw Exception('Article not found');
    }
  }
}
