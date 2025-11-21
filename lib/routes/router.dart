import 'package:nylo_framework/nylo_framework.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/add_task_page.dart';
import '/resources/pages/detail_task_page.dart';

appRouter() => nyRoutes((router) {
  router.route(HomePage.path, (context) => HomePage());
  router.route(AddTaskPage.path, (context) => AddTaskPage());
  router.route(DetailTaskPage.path, (context) => DetailTaskPage());

  // Initial route
  router.route("/", (context) => HomePage(), initialRoute: true);
});
