import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  var _dbReference = FirebaseDatabase.instance.reference();

  save(PostDto post) async {
    String postId =  _dbReference.child('/posts/').push().key;
    return await _dbReference.child('/posts/$postId').set(post.toJson());
  }
}