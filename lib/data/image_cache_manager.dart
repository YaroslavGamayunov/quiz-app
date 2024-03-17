import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class QuestionImagesCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'questionImagesCachedData';

  static final QuestionImagesCacheManager _instance =
      QuestionImagesCacheManager._();

  factory QuestionImagesCacheManager() {
    return _instance;
  }

  QuestionImagesCacheManager._()
      : super(Config(key,
            stalePeriod: Duration(days: 180), maxNrOfCacheObjects: 100));
}
