class Gif {
  String? name;
  String? url;
  double? duration;
  String? preview;
  List<int>? dims;
  int? size;

  Gif({
    this.name,
    this.url,
    required this.duration,
    this.preview,
    this.dims,
    this.size
  });
}