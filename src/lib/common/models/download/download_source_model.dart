import 'package:mediadrip/common/models/download/index.dart';
import 'package:mediadrip/common/models/drip_model.dart';
import 'package:mediadrip/common/models/source_model.dart';

abstract class DownloadSourceModel extends SourceModel {
  DownloadInstructionsModel configureDownload(DripModel drip);
}