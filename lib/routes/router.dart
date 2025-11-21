import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/resources/pages/home_page.dart';
import '/resources/pages/add_task_page.dart';
import '/resources/pages/detail_task_page.dart';

appRouter() => nyRoutes((router) {
  router.route(HomePage.path, (context) => const HomePage());
  router.route(AddTaskPage.path, (context) => const AddTaskPage());
  router.route(DetailTaskPage.path, (context) => const DetailTaskPage());

  // Initial route
  router.route("/", (context) => const HomePage(), initialRoute: true);
});
