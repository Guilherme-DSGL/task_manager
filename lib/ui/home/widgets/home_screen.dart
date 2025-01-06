import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:task_manager/ui/todo/view_models/todo_screen_view_model.dart';

import '../../core/ui/widgets/custom_app_bar.dart';
import '../../core/ui/widgets/navigation_bottom_icon.dart';
import '../../todo/widgets/todo_screen.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> screens = [
    TodoScreen(viewModel: TodoScreenViewModel()),
    const Center(child: Text('Notifications Screen')),
    const Center(child: Text('Profile Screen')),
    const Center(child: Text('Settings Screen')),
  ];

  int get currentIndexValue => widget.viewModel.currentIndex.value;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
          userName: "Jhon",
          userPhoto: "assets/images/userPhoto.jpg",
        ),
        body: ListenableBuilder(
          listenable: widget.viewModel.currentIndex,
          builder: (context, _) {
            return IndexedStack(
              index: currentIndexValue,
              children: screens,
            );
          },
        ),
        bottomNavigationBar: ListenableBuilder(
            listenable: widget.viewModel.currentIndex,
            builder: (context, _) {
              return SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  onTap: (index) {
                    widget.viewModel.setIndex(index);
                  },
                  currentIndex: currentIndexValue,
                  items: _bottomNavigationItems,
                ),
              );
            }),
      ),
    );
  }

  final _bottomNavigationItems = [
    const BottomNavigationBarItem(
      icon: NavigationBottomIcon(Symbols.event_list_rounded),
      label: 'Todo',
    ),
    const BottomNavigationBarItem(
      icon: NavigationBottomIcon(
        Icons.add,
        useRoundedShape: true,
      ),
      label: 'Create',
    ),
    const BottomNavigationBarItem(
      icon: NavigationBottomIcon(Icons.search),
      label: 'Search',
    ),
    const BottomNavigationBarItem(
      icon: NavigationBottomIcon(
        Icons.done,
        useRoundedShape: true,
      ),
      label: 'Done',
    ),
  ];
}
