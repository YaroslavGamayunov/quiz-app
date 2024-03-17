import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../data/image_cache_manager.dart';
import '../../data/questions.dart';

Future<void> preloadQuestionData(List<Question> questions) async {
  List<String> urls = [];
  questions.forEach((question) {
    if (question is QuestionWithImages) {
      urls += question.imageUrls;
    }
  });
  List<Future<FileInfo>> imageDownloadFutures = urls
      .map((url) => QuestionImagesCacheManager().downloadFile(url))
      .toList();

  Future.wait(imageDownloadFutures);
}
