import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/config/assets.dart';
import 'package:task_manager/ui/core/ui/widgets/custom_modal_bottom_sheet.dart';

import '../../core/ui/widgets/custom_app_bar.dart';
import '../../core/ui/widgets/navigation_bottom_icon.dart';
import '../../todo_done_list/view_models/todo_done_list_view_model.dart';
import '../../todo_done_list/widgets/todo_done_list_screen.dart';
import '../../todo_form/view_models/todo_form_view_model.dart';
import '../../todo_form/widgets/todo_form_screen.dart';
import '../../todo_list/view_models/todo_screen_view_model.dart';
import '../../todo_list/widgets/todo_screen.dart';
import '../../todo_search/view_model/todo_search_view_model.dart';
import '../../todo_search/widgets/todo_search_screen.dart';
import '../view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required HomeViewModel homeViewModel,
  }) : _homeViewModel = homeViewModel;

  final HomeViewModel _homeViewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get currentIndexValue => widget._homeViewModel.currentIndex.value;

  final pageController = PageController(initialPage: 0);

  List<Widget> get screens => [
        TodoScreen(
          todoScreenViewModel: context.read<TodoScreenViewModel>(),
        ),
        const SizedBox.shrink(),
        TodoSearchScreen(
          todoSearchScreenViewModel: context.read<TodoSearchViewModel>(),
        ),
        TodoDoneListScreen(
          todoDoneListViewModel: context.read<TodoDoneListViewModel>(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(
          userName: "Jhon",
          userPhoto: Assets.userPhoto,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            widget._homeViewModel.setIndex(index);
          },
          physics: const NeverScrollableScrollPhysics(),
          children: screens
              .map(
                (screen) => Builder(builder: (context) => screen),
              )
              .toList(),
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: widget._homeViewModel.currentIndex,
            builder: (context, _, __) {
              return SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  onTap: _onTapNavigationBarItem,
                  currentIndex: currentIndexValue,
                  items: _bottomNavigationItems,
                ),
              );
            }),
      ),
    );
  }

  void _onTapNavigationBarItem(int index) {
    const createBottomPage = 1;
    if (index == createBottomPage) {
      showCustomModalBottomSheet(
        context,
        builder: (modalContext) => TodoFormScreen(
          createTodoViewModel: context.read<TodoFormViewModel>(),
        ),
      );

      return;
    }
    widget._homeViewModel.setIndex(index);
    pageController.jumpToPage(index);
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
