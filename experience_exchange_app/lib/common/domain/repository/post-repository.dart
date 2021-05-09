import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  var _dbReference = FirebaseDatabase.instance.reference();

  save(PostDto post) async {
    String postId =  _dbReference.child('/posts/').push().key;
    return await _dbReference.child('/posts/$postId').set(post.toJson());
  }

  Future<List<PostDto>> getByUid(String uid) async {

    List<PostDto> posts = <PostDto>[];

    var queryResult = await _dbReference.child('/posts/').orderByChild('uid').equalTo(uid).once().then((result) {
      Map<dynamic, dynamic> postsModel = result.value;
      postsModel;

      postsModel.forEach((key, value) {
        // var post
        // var value = post;

        PostDto postDto = PostDto(value['uid'], value['mediaUrl'], value['text'], value['upvotes']);
        posts.add(postDto);
      });


      return posts;
    });


  }
}