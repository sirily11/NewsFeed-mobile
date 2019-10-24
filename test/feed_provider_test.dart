import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:newsfeed_mobile/models/FeedProvider.dart';


class MockCat extends Mock implements Dio {
  @override
  Future<Response<T>> get<T>(String path, {Map<String, dynamic> queryParameters, Options options, CancelToken cancelToken, onReceiveProgress}) {
    if(path.contains("pub"))
    
    return null;
  }

}


void main(){
  
  group("Test Feed Provider", (){
    FeedProvider feedProvider;

   setUpAll((){

   });



  });
}