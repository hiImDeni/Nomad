import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/comment/commentdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';

class PostRepository {
  var _dbReference = FirebaseFirestore.instance.collection('posts');

  save(PostDto post) async {
    String key = _dbReference.doc().id;
    post.postId = key;
    await _dbReference.doc(key).set(post.toJson());
  }

  Stream getByUid(String uid) => _dbReference.where('uid', isEqualTo: uid).orderBy('date', descending: true).snapshots();

  upvote(String postId, String uid) async {
    await _dbReference.doc(postId).collection('upvoteDtos').doc(uid).set({});
    await _dbReference.doc(postId).update({'upvotes': FieldValue.increment(1)});
  }

  unvote(String postId, String uid) async {
    await _dbReference.doc(postId).collection('upvoteDtos').doc(uid).delete();
    await _dbReference.doc(postId).update({'upvotes': FieldValue.increment(-1)}); //?
  }

  Future<bool> isUpvoted(String postId, String uid) async {
    return _dbReference.doc(postId).collection('upvoteDtos').doc(uid).get().then((value) {
      return value.exists;
    });
  }

  comment(String postId, CommentDto comment) async {
    await _dbReference.doc(postId).collection('commentDtos').doc().set(comment.toJson());
    await _dbReference.doc(postId).update({'comments': FieldValue.increment(1)});
  }

  Stream getComments(String postId) => _dbReference.doc(postId).collection('commentDtos').snapshots();
}