import 'package:experience_exchange_app/common/domain/repository/upvote-repository.dart';
import 'package:flutter/cupertino.dart';

class UpvoteService extends ChangeNotifier {
  final UpvoteRepository _upvoteRepository = UpvoteRepository();

  Future<bool> getUpvote(String postId, String uid) async {
    return await _upvoteRepository.getUpvote(postId, uid);
  }
}