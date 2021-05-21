import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:experience_exchange_app/common/domain/dtos/upvote/upvotedto.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  // var _dbReference = FirebaseDatabase.instance.reference();
  var _dbReference = FirebaseFirestore.instance.collection('posts');

  save(PostDto post) async {
    String key = _dbReference.doc().id;
    post.postId = key;
    await _dbReference.doc(key).set(post.toJson());
    // post.postId = postId;
    // return await _dbReference.child('/posts/$postId').set(post.toJson());
  }

  Stream getByUid(String uid) => _dbReference.where('uid', isEqualTo: uid).snapshots();

  upvote(String postId, String uid) async {
    await _dbReference.doc(postId).collection('upvoteDtos').doc(uid).set({});
    await _dbReference.doc(postId).update({'upvotes': FieldValue.increment(1)});
  }

  unvote(String postId, String uid) async {
    await _dbReference.doc(postId).collection('upvoteDtos').doc(uid).delete();
    await _dbReference.doc(postId).update({'upvotes': FieldValue.increment(-1)}); //?
  }

  Future<bool> isUpvoted(String postId, String uid) async {
    return _dbReference.doc(postId).collection('upvoteDtos').doc(uid).get() != null; //?
  }
}