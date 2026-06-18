import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshpickkat_admin/firebase_options.dart';
import 'package:freshpickkat_admin/screens/auth_wrapper.dart';
import 'package:freshpickkat_admin/screens/login_screen.dart';
import 'package:freshpickkat_admin/screens/main_screen.dart';
import 'package:freshpickkat_admin/tracking/controllers/delivery_tracking_controller.dart';
import 'package:freshpickkat_admin/services/admin_realtime_service.dart';
import 'package:freshpickkat_admin/services/admin_notification_navigation_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/theme/admin_theme_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(DeliveryTrackingController(), permanent: true);
  Get.put(AdminRealtimeService(), permanent: true);
  Get.put(AdminNotificationNavigationService(), permanent: true);
  Get.put(AdminThemeController(), permanent: true);

  runApp(const FreshPickKatAdmin());
}

class FreshPickKatAdmin extends StatelessWidget {
  const FreshPickKatAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<AdminThemeController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final mq = MediaQuery.of(context);
        final rawWidth = constraints.maxWidth;
        final rawHeight = constraints.maxHeight;

        const double baseWidth = 645;
        const double baseHeight = 932;
        const double screenUtilWidth = 430;
        final isWideWeb = kIsWeb && rawWidth > baseWidth;
        final scale = rawHeight / baseHeight;
        final containerWidth = (baseWidth * scale).clamp(430.0, 800.0).toDouble();
        final effectiveWidth = isWideWeb ? screenUtilWidth : rawWidth;

        return MediaQuery(
          data: mq.copyWith(
            size: Size(effectiveWidth, mq.size.height),
            textScaler: AdminResponsive.clampedTextScaler(context),
          ),
          child: ScreenUtilInit(
            designSize: AdminResponsive.designSize,
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, _) => Obx(
              () => GetMaterialApp(
                title: 'FreshPickKart Admin',
                debugShowCheckedModeBanner: false,
                theme: AdminAppTheme.light(),
                darkTheme: AdminAppTheme.dark(),
                themeMode: themeController.themeMode.value,
                builder: (context, child) {
                  if (child == null) return const SizedBox.shrink();
                  if (!isWideWeb) return child;
                  return Container(
                    color: const Color(0xFFEDEDED),
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: containerWidth,
                      child: child,
                    ),
                  );
                },
                initialRoute: '/',
                routes: {
                  '/': (context) => const AuthWrapper(),
                  '/login': (context) => const LoginScreen(),
                  '/main': (context) => const MainScreen(),
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
