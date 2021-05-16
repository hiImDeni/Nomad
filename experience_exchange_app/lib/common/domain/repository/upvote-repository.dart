import 'package:experience_exchange_app/common/domain/dtos/upvote/upvotedto.dart';
import 'package:firebase_database/firebase_database.dart';

class UpvoteRepository {
  var _dbReference = FirebaseDatabase.instance.reference();

  Future<bool> getUpvote(String postId, String uid) async {
    await _dbReference.child('/upvotes/$postId')
        // .orderByChild('postId').equalTo(postId)
        .orderByChild('uid').equalTo(uid)
        .once().then((result) {
          return result != null;
        }); //?
  }

  upvote(UpvoteDto upvote) async {
    await _dbReference.child('upvotes/${upvote.postId}').set(upvote.toJson());
  }

  unvote(String postId, String uid) async {
    await _dbReference.child('upvotes/$postId').orderByChild('uid').equalTo(uid).reference().remove();
    // once().then((result) {
    //   if (result != null) {
    //     result.re
    //   }
    // });
  }
}