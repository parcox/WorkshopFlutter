import '/resources/themes/dark_theme.dart';
import '/resources/themes/light_theme.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/styles/dark_theme_colors.dart';
import '/resources/themes/styles/light_theme_colors.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Flutter Themes
|--------------------------------------------------------------------------
| Run the below in the terminal to add a new theme.
| "dart run nylo_framework:main make:theme bright_theme"
|
| Learn more: https://nylo.dev/docs/6.x/themes-and-styling
|-------------------------------------------------------------------------- */

// App Themes
final List<BaseThemeConfig<ColorStyles>> appThemes = [
  BaseThemeConfig<ColorStyles>(
    id: 'light_theme',
    description: "Light theme",
    theme: lightTheme,
    colors: LightThemeColors(),
  ),
  BaseThemeConfig<ColorStyles>(
    id: 'dark_theme',
    description: "Dark theme",
    theme: darkTheme,
    colors: DarkThemeColors(),
  ),
];
