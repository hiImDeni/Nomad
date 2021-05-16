import 'package:experience_exchange_app/common/domain/dtos/post/postdto.dart';
import 'package:firebase_database/firebase_database.dart';

class PostRepository {
  var _dbReference = FirebaseDatabase.instance.reference();
  List<PostDto> posts = [];

  // _initializeData() async {
  //   await _dbReference.child('/posts/').then((result) {
  //     Map<dynamic, dynamic> postsModel = result.value;
  //     postsModel;
  //
  //     postsModel.forEach((key, value) {
  //       // var post
  //       // var value = post;
  //
  //       PostDto postDto = PostDto(key, value['uid'], value['mediaUrl'], value['text'], value['upvotes'], value['upvoteDtos']);
  //       posts.add(postDto);
  //     });
  // }

  save(PostDto post) async {
    String postId =  _dbReference.child('/posts/').push().key;
    await _dbReference.child('/posts/$postId').set(post.toJson()).then((value) {
      post.postId = postId;
      posts.add(post);
    });
  }

  Future<List<PostDto>> getByUid(String uid) async {
    var queryResult = await _dbReference.child('/posts/').orderByChild('uid').equalTo(uid).once().then((result) {
      List<PostDto> posts = <PostDto>[];
      Map<dynamic, dynamic> postsModel = result.value;

      postsModel.forEach((key, value) {
        if (value['uid'] == uid) {
          PostDto postDto = PostDto(
              // key,
              value['uid'],
              value['mediaUrl'],
              value['text'],
              // value['upvotes'],
              value['upvoteDtos']);
          posts.add(postDto);
        }
      });

      return posts;//.where((post) => post.uid == uid);
    });
  }
}