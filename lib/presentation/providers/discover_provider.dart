import 'package:flutter/material.dart';
import 'package:toktik/domain/entities/video_post.dart';
import 'package:toktik/domain/repositories/video_post_repository.dart';

class DiscoverProvider extends ChangeNotifier{

  final VideoPostRepository videoPostRepository;

  DiscoverProvider({
    required this.videoPostRepository
  });

  bool initialLoading = true;
  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {

    //await Future.delayed( const Duration(seconds: 2));
    
    final newVideos = await videoPostRepository.getTrendingVideosByPage(1);

    videos.addAll( newVideos);
    initialLoading = false;
    notifyListeners();
  }
}