import 'package:flutter/material.dart';
import 'package:mediadrip/common/widgets/drip_wrapper.dart';
import 'package:mediadrip/utilities/routes.dart';

class ToolsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DripWrapper(
      title: 'Tools',
      route: Routes.tools,
      child: Text('Currently unavailable until a crossplatform file picker is supported.'),
    );
  }
}