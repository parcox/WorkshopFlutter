import '/resources/widgets/theme_toggle_widget.dart';
import '/app/networking/api_service.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/logo_widget.dart';
import '/resources/widgets/safearea_widget.dart';
import '/app/controllers/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static RouteView path = ("/home", (_) => HomePage());

  HomePage({super.key}) : super(child: () => _HomePageState());
}

class _HomePageState extends NyPage<HomePage> {
  int? _stars;

  @override
  get init => () async {
        /// Uncomment the code below to fetch the number of stars for the Nylo repository
        // Map<String, dynamic>? githubResponse = await api<ApiService>(
        //         (request) => request.githubInfo(),
        // );
        // _stars = githubResponse?["stargazers_count"];
      };

  /// Define the Loading style for the page.
  /// Options: LoadingStyle.normal(), LoadingStyle.skeletonizer(), LoadingStyle.none()
  /// uncomment the code below.
  @override
  LoadingStyle get loadingStyle => LoadingStyle.normal();

  /// The [view] method displays your page.
  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon besar
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              // Text dengan style
              const Text(
                "Hello Flutter with Nylo!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              const Text(
                "Workshop Simple ToDo App",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              // Button
              ElevatedButton(
                onPressed: () {
                  // Show toast notification
                  showToastNotification(
                    context,
                    title: "Hello!",
                    description: "Selamat datang di Workshop Flutter",
                    style: ToastNotificationStyleType.success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Lihat ToDo List",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
