import 'package:auto_route/auto_route.dart';
import 'package:elementary_todo/app/router/app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: TasksRoute.page,
        ),
        AutoRoute(
          page: TaskDetailsRoute.page,
          path: '/task',
        ),
      ];
}
