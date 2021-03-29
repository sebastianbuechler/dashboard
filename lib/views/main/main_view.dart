import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'main_viewmodel.dart';

/// Main view container that handles rendering pages according to which bottom
/// navigation bar item is tapped
///   - can be replaced with a [TabView]
class MainView extends StatelessWidget {
  // final _views = <Widget>[
  //   FadeIn(
  //     child: GoalOverviewView(),
  //   ),
  //   FadeIn(
  //     child: PaymentsView(),
  //   ),
  //   FadeIn(
  //     child: ProfileView(),
  //   ),
  //   FadeIn(
  //     child: SettingsView(),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    // final local = AppLocalizations.of(context);

    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(maintainBottomViewPadding: true, child: Text('Main')
            // LazyIndexedStack(
            //   reuse: false,
            //   index: model.index,
            //   itemCount: _views.length,
            //   itemBuilder: (_, index) => _views[index],
            // ),
            ),
      ),
    );
  }
}
