import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/domain/repository/post-repository.dart';
import 'package:flutter/cupertino.dart';

class PostService extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();

  createPost(PostDto post) async {
    await _postRepository.save(post);
  }

  Stream getByUid(String uid) => _postRepository.getByUid(uid);

  upvote(String postId, String uid) async {
    return await _postRepository.upvote(postId, uid);
  }

  unvote(String postId, String uid) async {
    return await _postRepository.unvote(postId, uid);
  }

  Future<bool> isUpvoted(String postId, String uid) async{
    return await _postRepository.isUpvoted(postId, uid);
  }
}