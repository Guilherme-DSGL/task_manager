import 'package:go_router/go_router.dart';

import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/home/widgets/home_screen.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return HomeScreen(
              viewModel: HomeViewModel(),
            );
          },
        ),
      ],
    );
