import 'package:flutter/material.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:toktik/insfrastructure/datasources/local_video_datasource_impl.dart';
import 'package:toktik/insfrastructure/repositories/video_post_repository_impl.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/screens/discover/discover_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

final videoPostRepository = VideoPostsRepositoryImpl(
      videosDatasource: LocalVideoDatasource()
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => DiscoverProvider(videoPostRepository: videoPostRepository)..loadNextPage()),
      ],
      child: MaterialApp(
        title: 'TokTik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        home: const DiscoverScreen(),
      ),
    );
  }
}
