import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/home/view_models/home_viewmodel.dart';

import '../config/dependencies.dart';
import '../ui/home/widgets/home_screen.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return MultiProvider(
              providers: homeScreenProviders,
              builder: (context, _) => HomeScreen(
                homeViewModel: context.read<HomeViewModel>(),
              ),
            );
          },
        ),
      ],
    );
