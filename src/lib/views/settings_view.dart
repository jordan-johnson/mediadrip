import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediadrip/common/widgets/collections/index.dart';
import 'package:mediadrip/common/widgets/drip_wrapper.dart';
import 'package:mediadrip/utilities/routes.dart';
import 'package:mediadrip/views/models/settings_view_model.dart';
import 'package:mediadrip/views/providers/view_model_provider.dart';

class SettingsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SettingsViewModel>(
      model: SettingsViewModel(context: context),
      builder: (model) {
        return DripWrapper(
          title: 'Settings',
          route: Routes.settings,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => model.save(),
              child: Icon(Icons.save),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Container(
                child: ListView(
                  children: [
                    CardOfListTiles(
                      title: 'Storage Configuration',
                      icon: Icons.folder,
                      children: [
                        TextField(
                          controller: model.applicationStorageTextController..text = model.applicationStorage,
                          decoration: InputDecoration(
                            labelText: 'Application Storage Directory',
                            prefixIcon: Icon(Icons.folder_open),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                    CardOfListTiles(
                      title: 'Youtube Downloader',
                      icon: Icons.cloud_download,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.update
                          ),
                          title: Text('Automatic updates'),
                          trailing: Switch(
                            value: true,
                            onChanged: (_) => print(''),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          onTap: () => model.toggleDarkMode(),
                        ),
                        ListTile(
                          title: Text('Manage configuration'),
                          leading: Icon(
                            Icons.settings_applications
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right
                          ),
                          onTap: () => model.goToYoutubeConfiguration()
                        ),
                      ],
                    ),
                    CardOfListTiles(
                      title: 'RSS Feed',
                      icon: Icons.rss_feed,
                      children: [
                        TextField(
                          controller: model.rssFeedMaxEntriesTextController..text = model.feedMaxEntries,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Max Entries',
                            prefixIcon: Icon(Icons.format_list_numbered),
                            alignLabelWithHint: true,
                          ),
                        ),
                        ListTile(
                          title: Text('Manage feeds'),
                          leading: Icon(
                            Icons.edit
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right
                          ),
                          onTap: () => model.goToFeedConfiguration()
                        )
                      ],
                    ),
                    CardOfListTiles(
                      title: 'Theme Customization',
                      icon: Icons.smartphone,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.settings_brightness
                          ),
                          title: Text('Dark Mode'),
                          trailing: Switch(
                            value: model.darkMode,
                            onChanged: (_) => model.toggleDarkMode(),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          onTap: () => model.toggleDarkMode(),
                        ),
                      ],
                    )
                  ],
                )
              )
            ),
          )
        );
      },
    );
  }
}