import 'package:flutter_application_1/modules/courses/blocs/single_playlist_child.dart';

class SinglePlaylistItemBloc {
  SinglePlaylistItemBloc({
    required this.title,
    required this.children
  });

  final String title;
  final List<SinglePlaylistChildBloc> children;
}