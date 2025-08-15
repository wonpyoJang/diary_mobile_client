import 'package:diary_mobile_client/src/feature/moment/write_moment/presentation/write_moment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/settings_view.dart';
import '../../application/moments/moment_list_bloc.dart' as bloc;
import '../../application/moments/moment_list_state.dart';
import '../../presentation/widgets/write_moment_button.dart';
import 'widgets/moment_card.dart';
import 'package:diary_mobile_client/l10n/app_localizations.dart';

/// Displays a list of SampleItems.
class MomentListPage extends StatefulWidget {
  const MomentListPage({
    super.key,
  });

  static const routeName = '/moments';

  @override
  MomentListPageState createState() => MomentListPageState();
}

class MomentListPageState extends State<MomentListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myMemories),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: BlocBuilder<bloc.MomentListBloc, MomentListState>(
        builder: (context, state) {
          if (state.moments.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.registerNewDiary));
          }

          return ListView.builder(
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'sampleItemListView',
            itemCount: state.moments.values.expand((list) => list).length,
            itemBuilder: (BuildContext context, int index) {
              final item =
                  state.moments.values.expand((list) => list).toList()[index];

              return MomentCard(
                  item: item,
                  onTap: () {
                    Navigator.of(context).pushNamed(WriteMomentPage.routeName,
                        arguments: WriteMomentPageArguments(
                            moment: item, isBlendMode: true, date: item.date));
                  });
            },
          );
        },
      ),
      floatingActionButton: WriteMomentButton(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WriteMomentPage(
                  arguments: WriteMomentPageArguments(
                      moment: null, isBlendMode: true, date: DateTime.now()))));
        },
      ),
    );
  }
}
