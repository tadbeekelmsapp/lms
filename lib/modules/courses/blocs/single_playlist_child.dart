enum PlaylistChildType {
  video, doc, quiz
}

class SinglePlaylistChildBloc {
  SinglePlaylistChildBloc({
    required this.title,
    required this.link,
    this.type = PlaylistChildType.video,
    this.index
  });

  final String title;
  final String link;
  PlaylistChildType? type;
  int? index;
}