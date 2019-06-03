import '../widgets/page/dripPage.dart';
import 'util/pageWrapper.dart';

class DownloadPage extends DripPage {
  @override
  String get route => '/download';

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: Text(
        'this is the download page!',
        style: Theme.of(context).textTheme.display1
      )
    );
  }
}