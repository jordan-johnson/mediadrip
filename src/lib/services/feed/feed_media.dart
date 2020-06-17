import 'package:mediadrip/services/feed/feed_thumbnail.dart';
import 'package:mediadrip/services/feed/helper.dart';
import 'package:xml/xml.dart';

class FeedMedia {
  final String title;
  final FeedThumbnail thumbnail;
  final String description;

  FeedMedia({
    this.title,
    this.thumbnail,
    this.description
  });

  factory FeedMedia.parse(XmlElement element) {
    return FeedMedia(
      title: findElementOrNull(element, 'media:title').text,
      thumbnail: FeedThumbnail.parse(findElementOrNull(element, 'media:thumbnail')),
      description: findElementOrNull(element, 'media:description').text
    );
  }
}